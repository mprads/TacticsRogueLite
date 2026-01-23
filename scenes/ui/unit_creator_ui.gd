class_name UnitCreatorUI
extends Control

signal unit_created(unit_stats: UnitStats)

@export var header_text: String = "Give Your %s %s Unit A Name"
@export var unit_stats: UnitStats:
	set = set_unit_stats

@onready var ability_container: VBoxContainer = %AbilityContainer
@onready var line_edit: LineEdit = %LineEdit

@onready var unit_details_panel: UnitDetailsPanel = %UnitDetailsPanel
@onready var unit_icon_panel: UnitIconPanel = %UnitIconPanel
@onready var bottle_ability_panel: AbilityPanel = %BottleAbilityPanel
@onready var header_label: Label = %HeaderLabel


func _ready() -> void:
	line_edit.text_submitted.connect(_on_line_edit_text_submitted)


func set_unit_stats(value: UnitStats) -> void:
	unit_stats = value
	var bottle_name := ""
	var potion_name := ""

	if not unit_stats:
		return

	unit_details_panel.unit_stats = unit_stats
	unit_icon_panel.unit_stats = unit_stats

	bottle_name = unit_stats.bottle.name

	if unit_stats.potion:
		potion_name = unit_stats.potion.name

	header_label.text = header_text %[bottle_name, potion_name]
	_update_ability_visuals()
	line_edit.grab_focus()


func _update_ability_visuals() -> void:
	for child in ability_container.get_children():
		child.queue_free()

	bottle_ability_panel.ability = unit_stats.bottle.base_abilities[0]

	if not unit_stats.potion:
		return

	for ability in unit_stats.potion.abilities:
		var ability_panel_instance := AbilityPanel.create_new(ability)
		ability_container.add_child(ability_panel_instance)


func _on_line_edit_text_submitted(value: String) -> void:
	unit_stats.name = value
	line_edit.clear()
	unit_created.emit(unit_stats)
