extends Area2D
class_name MapRoom

signal selected(room: Room)

const ICONS := {
	Room.TYPE.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.TYPE.KILN: [preload("res://assets/icons/map/Kiln.png"), Vector2.ONE],
	Room.TYPE.BREWING: [preload("res://assets/icons/map/Brewing.png"), Vector2.ONE],
	Room.TYPE.SHOP: [preload("res://assets/icons/map/Shop.png"), Vector2.ONE],
	Room.TYPE.BATTLE: [preload("res://assets/icons/map/Battle.png"), Vector2.ONE],
	Room.TYPE.ELITE: [preload("res://assets/icons/map/Elite.png"), Vector2.ONE],
}

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var line_2d: Line2D = $Visuals/Line2D
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var label: Label = $Label

var available := false : set = set_available
var room: Room : set = set_room


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return

	room.selected = true
	line_2d.visible = true  
	selected.emit(room)


func set_room(value: Room) -> void:
	room = value
	position = room.position
	line_2d.rotation_degrees = randi_range(0, 360)
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]

	# TODO remove this once better debugging tools added
	if room.battle_stats:
		label.visible = true
		var text = room.battle_stats.resource_path.split("/")
		label.text = text[4]


func set_available(value: bool) -> void:
	# TODO activate outline highlighter and play pulsing animation
	available = value

	if available:
		sprite_2d.modulate.a = 1
	else:
		sprite_2d.modulate.a = 0.4
