extends Resource
class_name Vial

@export_category("Visuals")
@export var outline_16: Texture2D
@export var fillint_16: Texture2D
@export var outline_32: Texture2D
@export var fillint_32: Texture2D

@export var potion: Potion : set = set_potion
@export var refill_quantity := 1


func set_potion(value: Potion) -> void:
	potion = value
	emit_changed()
