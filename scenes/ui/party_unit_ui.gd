class_name PartyUnitUI
extends Button

const ABILITY_PANEL_SCENE = preload("res://scenes/ui/ability_panel.tscn")

@export var unit_stats: UnitStats:
	set = set_unit_stats

@onready var unit_icon_panel: UnitIconPanel = %UnitIconPanel
@onready var unit_details_panel: UnitDetailsPanel = %UnitDetailsPanel
@onready var ability_container: VBoxContainer = %AbilityContainer


func _update_visuals() -> void:
	for child in ability_container.get_children():
		child.queue_free()

	if not unit_stats or not unit_stats.potion: 
		return

	for ability in unit_stats.potion.abilities:
		var ability_panel_instance := ABILITY_PANEL_SCENE.instantiate()
		ability_container.add_child(ability_panel_instance)
		ability_panel_instance.ability = ability


func set_unit_stats(value: UnitStats) -> void:
	unit_stats = value

	if not unit_stats:
		return

	unit_icon_panel.unit_stats = unit_stats
	unit_details_panel.unit_stats = unit_stats
	
	_update_visuals()
