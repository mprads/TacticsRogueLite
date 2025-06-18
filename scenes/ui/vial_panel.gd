class_name VialPanel
extends Button

@export var potion: Potion:
	set = _potion

@onready var label: Label = %Label
@onready var ability_container: HBoxContainer = %AbilityContainer


func _update_visuals() -> void:
	label.text = "%s Vial" % potion.name


func _potion(value: Potion) -> void:
	if not is_node_ready():
		await ready

	potion = value

	if not potion:
		return

	_update_visuals()
