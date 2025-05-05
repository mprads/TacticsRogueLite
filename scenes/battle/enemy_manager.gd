extends Node2D
class_name EnemyManager

signal enemy_selected(enemy: Enemy)
signal show_enemy_intent(enemy: Enemy)
signal request_clear_intent
signal all_enemies_defeated

const ENEMY = preload("res://scenes/enemy/enemy.tscn")
const BASE_AI = preload("res://resources/enemy_ai/base_ai.tres")

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

	if enemy_stats.is_empty(): return

	for stats in enemy_stats:
		var enemy_instance := ENEMY.instantiate()
		add_child(enemy_instance)
		enemy_instance.stats = stats.duplicate()
		enemy_instance.ai = BASE_AI.duplicate()
		unit_mover.setup_enemy(enemy_instance)
		enemy_instance.status_manager.statuses_applied.connect(_on_enemy_statuses_applied.bind(enemy_instance))
		enemy_instance.turn_completed.connect(_on_enemy_turn_completed.bind(enemy_instance))
		enemy_instance.enemy_selected.connect(_on_enemy_selected)
		enemy_instance.show_intent.connect(_on_enemy_show_intent)
		enemy_instance.request_clear_intent.connect(_on_enemy_request_clear_intent)
		enemy_instance.request_flood_fill.connect(_on_enemy_request_flood_fill.bind(enemy_instance))
		enemy_instance.request_clear_fill_layer.connect(_on_enemy_request_clear_fill_layer.bind(enemy_instance))


func add_enemies_to_grid(grid: ArenaGrid, tile_map: TileMapLayer) -> void:
	var spawn_tiles := arena.get_enemy_spawns()
	for enemy in get_children():
		var empty_tile = RNG.array_pick_random(spawn_tiles)
		spawn_tiles.erase(empty_tile)
		enemy.global_position = tile_map.get_global_from_tile(empty_tile)
		grid.add_unit(empty_tile, enemy)


func start_turn() -> void:
	if get_child_count() == 0 : return

	enemies_to_act.clear()
	for enemy in get_children():
		enemies_to_act.append(enemy)
		update_enemy_intent(enemy)

	RNG.array_shuffle(enemies_to_act)
	_next_enemy_turn()


func update_enemy_intent(enemy: Enemy) -> void:
	var targets = get_tree().get_nodes_in_group("player_unit")
	var targets_in_range: Array[Dictionary] = []
	var targets_out_of_range: Array[Dictionary] = []

	for target in targets:
		var result := {
			"target": target,
			"tiles": [],
			"starting_tile": Vector2i.ZERO
		}

		var target_tile := arena.get_tile_from_global(target.global_position)
		var enemy_tile := arena.get_tile_from_global(enemy.global_position)

		var distance := Utils.get_distance_between_tiles(enemy_tile, target_tile)
		var neighbour_tiles := arena.get_neighbour_tiles(target_tile)
		var filtered_neighbours: Array[Vector2i] = []

		if distance <= enemy.stats.movement + enemy.stats.attack_range:
			filtered_neighbours = neighbour_tiles.filter(func(neighbour_tile: Vector2i) -> bool:
				if arena.arena_grid.is_tile_occupied(neighbour_tile) and neighbour_tile != enemy_tile:
					return false

				var neighbour_distance := Utils.get_distance_between_tiles(enemy_tile, neighbour_tile)

				return neighbour_distance <= enemy.stats.movement
			)
		else:
			filtered_neighbours = neighbour_tiles.filter(func(neighbour_tile: Vector2i) -> bool:
				return not arena.arena_grid.is_tile_occupied(neighbour_tile) and neighbour_tile != enemy_tile
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
	enemy.ai.select_target(unit_mover.get_id_path)


func verify_intent(enemy: Enemy) -> void:
	if not enemy.ai.current_target: 
		update_enemy_intent(enemy)
		return

	if not get_tree().get_nodes_in_group("player_unit").has(enemy.ai.current_target):
		update_enemy_intent(enemy)
		return

	if arena.arena_grid.is_tile_occupied(enemy.ai.next_tile):
		update_enemy_intent(enemy)
		return


func _next_enemy_turn() -> void:
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
			enemies_to_act.erase(enemy)
			_next_enemy_turn()


func _on_enemy_selected(enemy: Enemy) -> void:
	enemy_selected.emit(enemy)


func _on_enemy_show_intent(enemy: Enemy) -> void:
	show_enemy_intent.emit(enemy)


func _on_enemy_died(enemy: Enemy) -> void:
	enemies_to_act.erase(enemy)
	remove_child(enemy)
	# TODO once dots are added going to to need to call _next_enemy_turn
	if get_child_count() == 0:
		all_enemies_defeated.emit()


func _on_enemy_request_flood_fill(max_distance: int, atlas_coord: Vector2i, enemy: Enemy) -> void:
	if not unit_mover.is_dragging():
		flood_filler.enabled = true
		var i := unit_mover.get_arena_for_position(enemy.global_position)
		var tile := unit_mover.arenas[i].get_tile_from_global(enemy.global_position)
		flood_filler.flood_fill_from_tile(tile, max_distance, true, atlas_coord)


func _on_enemy_request_clear_intent() -> void:
	request_clear_intent.emit()


func _on_enemy_request_clear_fill_layer(enemy: Enemy) -> void:
	if not unit_mover.is_dragging():
		var i := unit_mover.get_arena_for_position(enemy.global_position)
		unit_mover.arenas[i].clear_flood_filler("ENEMY")


func _on_request_update_enemy_intent() -> void:
	for enemy in get_children():
		update_enemy_intent(enemy)
