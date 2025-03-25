extends Resource
class_name Vial

@export_category("Visuals")
@export var outline: Texture2D
@export var filling: Texture2D

@export var potion: Potion : set = set_potion
@export var refill_quantity := 1


func set_potion(value: Potion) -> void:
	potion = value
	emit_changed()
