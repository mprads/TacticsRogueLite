class_name MapRoom
extends Area2D

signal selected(room: Room)

const ICONS := {
	Room.TYPE.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.TYPE.KILN: [preload("res://assets/icons/map/Kiln.png"), Vector2.ONE],
	Room.TYPE.BREWING: [preload("res://assets/icons/map/Brewing.png"), Vector2.ONE],
	Room.TYPE.SHOP: [preload("res://assets/icons/map/Shop.png"), Vector2.ONE],
	Room.TYPE.BATTLE: [preload("res://assets/icons/map/Battle.png"), Vector2.ONE],
	Room.TYPE.ELITE: [preload("res://assets/icons/map/Elite.png"), Vector2.ONE],
	Room.TYPE.BOSS: [preload("res://assets/icons/map/Boss.png"), Vector2.ONE],
}

@export var outline_thickness: float = 1.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var line_2d: Line2D = $Visuals/Line2D
@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var disabled_sprite: Sprite2D = $Visuals/DisabledSprite
@onready var available_sprite: Sprite2D = $Visuals/AvailableSprite

var available := false:
	set = set_available
var room: Room:
	set = set_room


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


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
	disabled_sprite.texture = ICONS[room.type][0]
	available_sprite.texture = ICONS[room.type][0]

	# TODO remove this once better debugging tools added
	if room.battle_stats:
		label.visible = true
		var text = room.battle_stats.resource_path.split("/")
		label.text = text[4]


func set_available(value: bool) -> void:
	available = value

	if available:
		# Need two sprites because there is an Godot engine issue when a texture has a material
		# that uses any colour causing it to overwrite the alpha, so I can't fade out unavailable rooms
		available_sprite.show()
		disabled_sprite.hide()
		await get_tree().create_timer(randf_range(0.0, .4)).timeout
		animation_player.play("available")
	else:
		available_sprite.hide()
		disabled_sprite.show()
		animation_player.stop()


func _on_mouse_entered() -> void:
	if not available:
		return

	available_sprite.material.set_shader_parameter("outline_thickness", outline_thickness)


func _on_mouse_exited() -> void:
	if not available:
		return

	available_sprite.material.set_shader_parameter("outline_thickness", 0.0)
