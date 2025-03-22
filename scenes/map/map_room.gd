extends Area2D
class_name MapRoom

signal selected(room: Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.KILN: [preload("res://assets/sprites/map/Kiln.png"), Vector2.ONE],
	Room.Type.BREWING: [preload("res://assets/sprites/map/Brewing.png"), Vector2.ONE],
	Room.Type.SHOP: [preload("res://assets/sprites/map/Shop.png"), Vector2.ONE],
	Room.Type.BATTLE: [preload("res://assets/sprites/map/Battle.png"), Vector2.ONE],
}

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var line_2d: Line2D = $Visuals/Line2D
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D

@onready var label: Label = $Label

var available := false : set = set_available
var room: Room : set = set_room


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return
	
	room.selected = true
	selected.emit(room)


func show_selected() -> void:
	line_2d.modulate = Color.WHITE


func set_room(value: Room) -> void:
	room = value
	position = room.position
	line_2d.rotation_degrees = randi_range(0, 360)
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]
	label.text = str(room.type)


func set_available(value: bool) -> void:
	# TODO activate outline highlighter and play pulsing animation
	available = value
