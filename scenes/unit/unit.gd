extends Area2D
class_name Unit

@export var stats: UnitStats : set = set_stats

@onready var outline: Sprite2D = $Visuals/Outline
@onready var filling: Sprite2D = $Visuals/Filling

@onready var drag_and_drop: DragAndDrop = $DragAndDrop


func _ready() -> void:
	drag_and_drop.drag_started.connect(_on_drag_started)
	drag_and_drop.drag_cancelled.connect(_on_drag_cancelled)


func set_stats(value: UnitStats) -> void:
	stats = value
	
	if value == null:
		return
	
	if not is_node_ready():
		await ready
		
	stats = value

	outline.region_rect.position = Vector2(stats.bottle.sprite_coordinates) * 32
	filling.region_rect.position = Vector2(stats.bottle.sprite_coordinates) * 32
	
	if stats.potion:
		filling.visible = true
		filling.modulate = stats.potion.color


func reset_after_dragging(starting_position: Vector2) -> void:
	global_position = starting_position


func _on_drag_started() -> void:
	pass


func _on_drag_cancelled(starting_position: Vector2) -> void:
	reset_after_dragging(starting_position)
