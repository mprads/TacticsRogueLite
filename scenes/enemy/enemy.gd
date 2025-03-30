extends Area2D
class_name Enemy

signal turn_completed

@export var stats: EnemyStats : set = set_enemy_stats

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var health_bar: ProgressBar = $HealthBar


func update_enemy() -> void:
	if not stats: return
	if not is_node_ready(): await ready
	
	sprite_2d.texture = stats.sprite
	health_bar.max_value = stats.max_health
	health_bar.value = stats.health


func set_enemy_stats(value: EnemyStats) -> void:
	stats = value
	
	if not stats: return
	if not stats.changed.is_connected(_on_stats_changed):
		stats.changed.connect(_on_stats_changed)
		
	update_enemy()


func take_turn() -> void:
	print("Turn completed %s" % stats.name)
	turn_completed.emit()

func _on_stats_changed() -> void:
	update_enemy()
