class_name Vial
extends Resource

@export_category("Visuals")
@export var outline: Texture2D
@export var filling: Texture2D

@export var potion: Potion:
	set = set_potion


func set_potion(value: Potion) -> void:
	potion = value
	emit_changed()
