class_name VialSelectButton
extends Button

const VIAL_SELECT_BUTTON_SCENE = preload("uid://k3fq1svq2il6")

@export var potion: Potion : set = set_potion

@onready var vial_button: VialButton = %VialButton
@onready var ability_container: HBoxContainer = %AbilityContainer


func set_potion(value: Potion) -> void:
	if not is_node_ready():
		await ready

	potion = value

	if not potion:
		return

	var new_vial = Vial.new()
	new_vial.potion = potion
	vial_button.vial = new_vial
	_update_ability_panels()


func _update_ability_panels() -> void:
	if not is_node_ready():
		await ready

	for child in ability_container.get_children():
		child.queue_free()

	for ability in potion.abilities:
		var new_panel := AbilityPanel.create_new(ability)
		ability_container.add_child(new_panel)


static func create_new(new_potion: Potion) -> VialSelectButton:
	var vial_select_button := VIAL_SELECT_BUTTON_SCENE.instantiate()
	vial_select_button.potion = new_potion
	return vial_select_button
