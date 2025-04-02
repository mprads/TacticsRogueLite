extends Node2D
class_name EnemyManager

const ENEMY = preload("res://scenes/enemy/enemy.tscn")

@export var unit_mover: UnitMover

var enemies_to_act: Array[Enemy] = [] 


func setup_enemies(enemy_stats: Array[EnemyStats]) -> void:
	for enemy in get_children():
		enemy.queue_free()
		
	if enemy_stats.is_empty(): return
	
	for stats in enemy_stats:
		var enemy_instance := ENEMY.instantiate()
		add_child(enemy_instance)
		enemy_instance.stats = stats.duplicate()
		enemy_instance.turn_completed.connect(_on_enemy_turn_completed)
		unit_mover.setup_enemy(enemy_instance)


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
		await get_tree().create_timer(.5).timeout
		Events.enemy_turn_ended.emit()
		return
	# TODO replace this with start and end of turn once dots are added
	var enemy = enemies_to_act[0]
	enemies_to_act.erase(enemy)
	await get_tree().create_timer(.5).timeout
	enemy.take_turn()


func _on_enemy_turn_completed() -> void:
	_next_enemy_turn()
