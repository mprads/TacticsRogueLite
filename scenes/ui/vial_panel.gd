class_name VialPanel
extends Button

@export var potion: Potion:
	set = _potion

@onready var label: Label = %Label
@onready var ability_container: HBoxContainer = %AbilityContainer


func _update_visuals() -> void:
	for child in ability_container.get_children():
		child.queue_free()

	if not potion: 
		return

	label.text = "%s Vial" % potion.name
	for ability in potion.abilities:
		var ability_panel_instance := AbilityPanel.create_new(ability)
		ability_container.add_child(ability_panel_instance)


func _potion(value: Potion) -> void:
	if not is_node_ready():
		await ready

	potion = value

	if not potion:
		return

	_update_visuals()
