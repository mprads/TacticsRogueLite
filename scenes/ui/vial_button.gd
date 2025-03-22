extends Button
class_name VialButton

@export var vial: Vial : set = set_vial

@onready var vial_filling: TextureRect = %VialFilling


func _update_visuals() -> void:
	if vial.potion:
		vial_filling.modulate = vial.potion.color
		vial_filling.visible = true
	else:
		vial_filling.visible = false


func set_vial(value: Vial) -> void:
	vial = value
	_update_visuals()
