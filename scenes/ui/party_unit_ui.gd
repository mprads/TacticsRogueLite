class_name PartyUnitUI
extends Button

const PARTY_UNIT_UI_SCENE = preload("uid://cnvnj7pvvkjhu")

@export var unit_stats: UnitStats:
	set = set_unit_stats

@onready var unit_icon_panel: UnitIconPanel = %UnitIconPanel
@onready var unit_details_panel: UnitDetailsPanel = %UnitDetailsPanel
@onready var potion_label: Label = %PotionLabel
@onready var ability_container: VBoxContainer = %AbilityContainer


func _update_visuals() -> void:
	for child in ability_container.get_children():
		child.queue_free()

	if not unit_stats or not unit_stats.potion: 
		return

	for ability in unit_stats.potion.abilities:
		var ability_panel_instance := AbilityPanel.create_new(ability)
		ability_container.add_child(ability_panel_instance)


func set_unit_stats(value: UnitStats) -> void:
	if not is_node_ready():
		await ready

	unit_stats = value

	if not unit_stats:
		return

	unit_icon_panel.unit_stats = unit_stats
	unit_details_panel.unit_stats = unit_stats
	potion_label.text = unit_stats.name
	
	_update_visuals()


static func create_new(new_stats: UnitStats) -> PartyUnitUI:
	var new_party_unit_ui := PARTY_UNIT_UI_SCENE.instantiate()
	new_party_unit_ui.unit_stats = new_stats
	return new_party_unit_ui
