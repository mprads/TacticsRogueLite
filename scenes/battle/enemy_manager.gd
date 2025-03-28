extends Node2D
class_name EnemyManager

const ENEMY = preload("res://scenes/enemy/enemy.tscn")

var enemies: Array[Enemy]


func setup_enemies(enemy_stats: Array[EnemyStats]) -> void:
	if enemy_stats.is_empty(): return
	
	for enemy in get_children():
		enemy.queue_free()
	
	for stats in enemy_stats:
		var enemy_instance := ENEMY.instantiate()
		add_child(enemy_instance)
		enemy_instance.stats = stats.duplicate()
