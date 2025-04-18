extends Area2D
class_name Enemy

signal request_enemy_move
signal turn_completed
signal enemy_selected(enemy: Enemy)
signal request_flood_fill(max_distance: int, atlas_coord: Vector2i)
signal request_clear_fill_layer

@export var stats: EnemyStats : set = set_enemy_stats

@onready var status_manager: StatusManager = $StatusManager
@onready var modifier_manager: ModifierManager = $ModifierManager
@onready var floating_text_spawner: FloatingTextSpawner = $FloatingTextSpawner

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var health_bar: ProgressBar = $HealthBar
@onready var shield_bar: ProgressBar = $ShieldBar

var selectable := false


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	status_manager.status_owner = self


func _input(event: InputEvent) -> void:
	if not selectable: return
	
	if event.is_action_pressed("left_mouse"):
		enemy_selected.emit(self)


func take_damage(damage: int) -> void:
	if not stats: return
	
	var modified_damage = modifier_manager.get_modified_value(damage, Modifier.TYPE.DAMAGE_TAKEN)
	stats.take_damage(modified_damage)
	spawn_floating_text(str(modified_damage), ColourHelper.get_colour(ColourHelper.KEYS.DAMAGE))


func spawn_floating_text(text: String, text_color) -> void:
	if not floating_text_spawner: return
	
	floating_text_spawner.spawn_text(text, text_color)


func move_cleanup() -> void:
	pass


func update_enemy() -> void:
	if not stats: return
	if not is_node_ready(): await ready
	
	sprite_2d.texture = stats.sprite
	health_bar.max_value = stats.max_health
	health_bar.value = stats.health
	shield_bar.max_value = stats.max_health
	shield_bar.value = stats.shield


func set_enemy_stats(value: EnemyStats) -> void:
	stats = value
	
	if not stats: return
	if not stats.changed.is_connected(_on_stats_changed):
		stats.changed.connect(_on_stats_changed)
		
	update_enemy()


func take_turn() -> void:
	request_enemy_move.emit()
	print("Turn completed %s" % stats.name)
	turn_completed.emit()


func _on_stats_changed() -> void:
	update_enemy()


func _on_mouse_entered() -> void:
	selectable = true
	# Clunky but when two enemies are next to each other the area2ds overlap
	# and mouse entered signal seems to have priority over exit signal
	# so create a lambda and delay till end of frame
	(func():
		request_flood_fill.emit(stats.movement, Vector2i(4, 0))
		).call_deferred()


func _on_mouse_exited() -> void:
	selectable = false
	request_clear_fill_layer.emit()
