class_name EnemyManager
extends Node2D

signal enemy_selected(enemy: Enemy)
signal show_enemy_intent(enemy: Enemy)
signal request_clear_intent
signal all_enemies_defeated

@export var unit_mover: UnitMover
@export var flood_filler: FloodFiller
@export var arena: Arena

var enemies_to_act: Array[Enemy] = []


func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)
	Events.request_update_enemy_intent.connect(_on_request_update_enemy_intent)


func setup_enemies(enemy_stats: Array[EnemyStats]) -> void:
	for enemy in get_children():
		enemy.queue_free()

	if enemy_stats.is_empty():
		return

	for stats in enemy_stats:
		var enemy_instance := Enemy.create_new(stats.scene, stats.duplicate())
		add_child(enemy_instance)
		unit_mover.setup_enemy(enemy_instance)
		enemy_instance.status_manager.statuses_applied.connect(
			_on_enemy_statuses_applied.bind(enemy_instance)
		)
		enemy_instance.turn_completed.connect(_on_enemy_turn_completed.bind(enemy_instance))
		enemy_instance.enemy_selected.connect(_on_enemy_selected)
		enemy_instance.show_intent.connect(_on_enemy_show_intent)
		enemy_instance.request_clear_intent.connect(_on_enemy_request_clear_intent)
		enemy_instance.request_flood_fill.connect(_on_enemy_request_flood_fill.bind(enemy_instance))
		enemy_instance.request_clear_fill_layer.connect(
			_on_enemy_request_clear_fill_layer.bind(enemy_instance)
		)


func add_enemies_to_grid(grid: ArenaGrid, tile_map: TileMapLayer) -> void:
	var spawn_tiles := arena.get_enemy_spawns()
	for enemy: Enemy in get_children():
		var valid_tiles: Array[Vector2i]

		while valid_tiles.size() < enemy.stats.dimensions.x * enemy.stats.dimensions.y:
			valid_tiles = []
			var empty_tile = RNG.array_pick_random(spawn_tiles)

			for i in enemy.stats.dimensions.x:
				for j in enemy.stats.dimensions.y:
					var temp_x = empty_tile.x - i
					var temp_y = empty_tile.y - j
					if not tile_map.is_tile_in_bounds(Vector2i(temp_x, temp_y)):
						continue
					if grid.is_tile_occupied(Vector2i(temp_x, temp_y)):
						continue
					valid_tiles.append(Vector2i(temp_x, temp_y))

		for tile in valid_tiles:
			spawn_tiles.erase(tile)
			grid.add_unit(tile, enemy)

		enemy.global_position = tile_map.get_global_from_tile(valid_tiles[0])


func start_turn() -> void:
	if get_child_count() == 0:
		return

	enemies_to_act.clear()
	for enemy in get_children():
		enemies_to_act.append(enemy)
		update_enemy_intent(enemy)

	RNG.array_shuffle(enemies_to_act)
	_next_enemy_turn()


func update_enemy_intent(enemy: Enemy) -> void:
	var enemy_tile := arena.get_tile_from_global(enemy.global_position)
	var targets = get_tree().get_nodes_in_group("player_unit")
	var targets_in_range: Array[Dictionary] = []
	var targets_out_of_range: Array[Dictionary] = []

	for target in targets:
		var result := {"target": target, "tiles": [], "starting_tile": Vector2i.ZERO}

		var target_tile := arena.get_tile_from_global(target.global_position)

		var distance := Utils.get_distance_between_tiles(enemy_tile, target_tile)
		var neighbour_tiles := arena.get_neighbour_tiles(target_tile)
		var filtered_neighbours: Array[Vector2i] = []

		if enemy.stats.dimensions.x * enemy.stats.dimensions.y > 1:
			var enemy_tiles: Array[Vector2i] = []
			for i in enemy.stats.dimensions.x:
				for j in enemy.stats.dimensions.y:
					enemy_tiles.append(Vector2i(enemy_tile.x - i, enemy_tile.y - j))

			for tile in enemy_tiles:
				var temp_filtered_neighbours = _filter_neighbours(
					distance, enemy.stats.movement, enemy.stats.attack_range, neighbour_tiles, tile
				)

				for temp_neighbour in temp_filtered_neighbours:
					if not filtered_neighbours.has(temp_neighbour):
						filtered_neighbours.append(temp_neighbour)
		else:
			filtered_neighbours = _filter_neighbours(
				distance,
				enemy.stats.movement,
				enemy.stats.attack_range,
				neighbour_tiles,
				enemy_tile
			)

		if not filtered_neighbours.is_empty():
			result["tiles"] = filtered_neighbours
			result["starting_tile"] = enemy_tile
			if distance <= enemy.stats.movement + enemy.stats.attack_range:
				targets_in_range.append(result)
			else:
				targets_out_of_range.append(result)

	enemy.ai.targets_in_range = targets_in_range
	enemy.ai.targets_out_of_range = targets_out_of_range
	enemy.ai.select_target(unit_mover.get_id_path, arena)


func verify_intent(enemy: Enemy) -> void:
	if not enemy.ai.current_target:
		update_enemy_intent(enemy)
		return
	
	if not enemy.ai.current_target.is_in_group("player_unit"):
		update_enemy_intent(enemy)
		return

	if not get_tree().get_nodes_in_group("player_unit").has(enemy.ai.current_target):
		update_enemy_intent(enemy)
		return

	if arena.arena_grid.is_tile_occupied(enemy.ai.next_tile):
		update_enemy_intent(enemy)
		return

	if Utils.get_distance_between_tiles(
		enemy.ai.next_tile,
		arena.get_tile_from_global(enemy.global_position)
	) > Utils.get_distance_between_tiles(
		arena.get_tile_from_global(enemy.ai.current_target.global_position),
		arena.get_tile_from_global(enemy.global_position)
	):
		update_enemy_intent(enemy)
		return


func _filter_neighbours(
	distance: int,
	movement_range: int,
	attack_range: int,
	neighbour_tiles: Array[Vector2i],
	enemy_tile: Vector2i
) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	if distance <= movement_range + attack_range:
		result = neighbour_tiles.filter(
			func(neighbour_tile: Vector2i) -> bool:
				if (
					arena.arena_grid.is_tile_occupied(neighbour_tile)
					and neighbour_tile != enemy_tile
				):
					return false

				var neighbour_distance := Utils.get_distance_between_tiles(
					enemy_tile, neighbour_tile
				)

				return neighbour_distance <= movement_range
		)
	else:
		result = neighbour_tiles.filter(
			func(neighbour_tile: Vector2i) -> bool:
				return (
					not arena.arena_grid.is_tile_occupied(neighbour_tile)
					and neighbour_tile != enemy_tile
				)
		)
	return result


func _next_enemy_turn() -> void:
	await get_tree().create_timer(1.0).timeout
	if enemies_to_act.is_empty():
		Events.enemy_turn_ended.emit()
		return

	enemies_to_act[0].status_manager.apply_statuses_by_type(Status.TYPE.START_OF_TURN)


func _on_enemy_turn_completed(enemy: Enemy) -> void:
	enemy.status_manager.apply_statuses_by_type(Status.TYPE.END_OF_TURN)


func _on_enemy_statuses_applied(type: Status.TYPE, enemy: Enemy) -> void:
	match type:
		Status.TYPE.START_OF_TURN:
			verify_intent(enemy)
			enemy.take_turn()
		Status.TYPE.END_OF_TURN:
			verify_intent(enemy)
			enemies_to_act.erase(enemy)
			_next_enemy_turn()


func _on_enemy_selected(enemy: Enemy) -> void:
	enemy_selected.emit(enemy)


func _on_enemy_show_intent(enemy: Enemy) -> void:
	show_enemy_intent.emit(enemy)


func _on_enemy_died(enemy: Enemy) -> void:
	enemies_to_act.erase(enemy)
	if is_instance_valid(enemy):
		remove_child(enemy)
	# TODO once dots are added going to to need to call _next_enemy_turn
	if get_child_count() == 0:
		all_enemies_defeated.emit()


func _on_enemy_request_flood_fill(max_distance: int, atlas_coord: Vector2i, enemy: Enemy) -> void:
	if not unit_mover.is_dragging():
		flood_filler.enabled = true
		var arena_index := unit_mover.get_arena_for_position(enemy.global_position)
		var tile := unit_mover.arenas[arena_index].get_tile_from_global(enemy.global_position)
		for i in enemy.stats.dimensions.x:
			for j in enemy.stats.dimensions.y:
				var temp_x = tile.x - i
				var temp_y = tile.y - j
				flood_filler.flood_fill_from_tile(
					Vector2i(temp_x, temp_y), max_distance, true, atlas_coord
				)


func _on_enemy_request_clear_intent() -> void:
	request_clear_intent.emit()


func _on_enemy_request_clear_fill_layer(enemy: Enemy) -> void:
	if not unit_mover.is_dragging():
		var i := unit_mover.get_arena_for_position(enemy.global_position)
		unit_mover.arenas[i].clear_flood_filler("ENEMY")


func _on_request_update_enemy_intent() -> void:
	for enemy in get_children():
		verify_intent(enemy)
