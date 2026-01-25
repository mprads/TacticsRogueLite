class_name VialPanel
extends Button

const VIAL_PANEL_SCENE = preload("uid://6m8egyaev33y")

@export var potion: Potion:
	set = set_potion

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


func set_potion(value: Potion) -> void:
	if not is_node_ready():
		await ready

	potion = value

	if not potion:
		return

	_update_visuals()


static func create_new(new_potion: Potion) -> VialPanel:
	var new_vial_panel := VIAL_PANEL_SCENE.instantiate()
	new_vial_panel.potion = new_potion
	return new_vial_panel
