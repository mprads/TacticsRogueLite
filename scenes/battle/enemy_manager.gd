extends Node2D
class_name EnemyManager

signal enemy_selected(enemy: Enemy)

const ENEMY = preload("res://scenes/enemy/enemy.tscn")

@export var unit_mover: UnitMover
@export var flood_filler: FloodFiller

var enemies_to_act: Array[Enemy] = [] 


func setup_enemies(enemy_stats: Array[EnemyStats]) -> void:
	for enemy in get_children():
		enemy.queue_free()
		
	if enemy_stats.is_empty(): return
	
	for stats in enemy_stats:
		var enemy_instance := ENEMY.instantiate()
		add_child(enemy_instance)
		enemy_instance.stats = stats.duplicate()
		unit_mover.setup_enemy(enemy_instance)
		enemy_instance.turn_completed.connect(_on_enemy_turn_completed)
		enemy_instance.enemy_selected.connect(_on_enemy_selected)
		enemy_instance.request_flood_fill.connect(_on_enemy_request_flood_fill.bind(enemy_instance))
		enemy_instance.request_clear_fill_layer.connect(_on_enemy_request_clear_fill_layer.bind(enemy_instance))


func add_enemies_to_grid(grid: ArenaGrid, tile_map: TileMapLayer) -> void:
	for enemy in get_children():
		var empty_tile = grid.get_first_empty_tile()
		enemy.global_position = tile_map.get_global_from_tile(empty_tile)
		grid.add_unit(empty_tile, enemy)


func start_turn() -> void:
	if get_child_count() == 0 : return
	
	enemies_to_act.clear()
	for enemy in get_children():
		enemies_to_act.append(enemy)

	_next_enemy_turn()


func _next_enemy_turn() -> void:
	if enemies_to_act.is_empty():
		await get_tree().create_timer(.25).timeout
		Events.enemy_turn_ended.emit()
		return
	# TODO replace this with start and end of turn once dots are added
	var enemy = enemies_to_act[0]
	enemies_to_act.erase(enemy)
	await get_tree().create_timer(.25).timeout
	enemy.take_turn()


func _on_enemy_turn_completed() -> void:
	_next_enemy_turn()


func _on_enemy_selected(enemy: Enemy) -> void:
	enemy_selected.emit(enemy)


func _on_enemy_request_flood_fill(max_distance: int, atlas_coord: Vector2i, enemy: Enemy) -> void:
	if not unit_mover.is_dragging():
		flood_filler.enabled = true
		var i := unit_mover.get_arena_for_position(enemy.global_position)
		var tile := unit_mover.arenas[i].get_tile_from_global(enemy.global_position)
		flood_filler.flood_fill_from_tile(tile, max_distance, true, atlas_coord)


func _on_enemy_request_clear_fill_layer(enemy: Enemy) -> void:
	if not unit_mover.is_dragging():
		var i := unit_mover.get_arena_for_position(enemy.global_position)
		unit_mover.arenas[i].clear_flood_filler("ENEMY")
