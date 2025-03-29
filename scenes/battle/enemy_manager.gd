extends Node2D
class_name EnemyManager

const ENEMY = preload("res://scenes/enemy/enemy.tscn")


func setup_enemies(enemy_stats: Array[EnemyStats]) -> void:
	for enemy in get_children():
		enemy.queue_free()
		
	if enemy_stats.is_empty(): return
	
	for stats in enemy_stats:
		var enemy_instance := ENEMY.instantiate()
		add_child(enemy_instance)
		enemy_instance.stats = stats.duplicate()


func add_enemies_to_grid(grid: ArenaGrid, tile_map: TileMapLayer) -> void:
	for enemy in get_children():
		var empty_tile = grid.get_first_empty_tile()
		enemy.global_position = tile_map.get_global_from_tile(empty_tile)
		grid.add_unit(empty_tile, enemy)
