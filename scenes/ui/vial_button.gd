class_name VialButton
extends Button

const VIAL_BUTTON_SCENE = preload("uid://bkyqjyhlg3ia0")

@export var vial: Vial:
	set = set_vial
@export var outline_thickness: float = 1.0

@onready var vial_filling: TextureRect = %VialFilling
@onready var vial_outline: TextureRect = %VialOutline


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _update_visuals() -> void:
	if vial.potion:
		vial_filling.modulate = vial.potion.color
		vial_filling.visible = true
	else:
		vial_filling.visible = false


func set_vial(value: Vial) -> void:
	if not is_node_ready():
		await ready

	vial = value
	if vial.potion:
		disabled = false

	_update_visuals()


func _on_mouse_entered() -> void:
	if not vial.potion:
		return

	vial_outline.material.set_shader_parameter("outline_thickness", outline_thickness)


func _on_mouse_exited() -> void:
	if not vial.potion:
		return

	vial_outline.material.set_shader_parameter("outline_thickness", 0.0)


static func create_new(new_vial: Vial) -> VialButton:
	var new_vial_button := VIAL_BUTTON_SCENE.instantiate()
	new_vial_button.vial = new_vial
	return new_vial_button
