extends Control
class_name UnitCreatorUI

signal unit_created(unit_stats: UnitStats)

const ABILITY_PANEL_SCENE = preload("res://scenes/ui/ability_panel.tscn")

@export var unit_stats: UnitStats :set = set_unit_stats

@onready var party_unit_ui: PartyUnitUI = %PartyUnitUI
@onready var ability_container: HBoxContainer = %AbilityContainer
@onready var line_edit: LineEdit = %LineEdit


func _ready() -> void:
	line_edit.text_submitted.connect(_on_line_edit_text_submitted)


func set_unit_stats(value: UnitStats) -> void:
	unit_stats = value

	if not unit_stats: return

	party_unit_ui.unit = unit_stats

	_update_ability_visuals()
	line_edit.grab_focus()


func _update_ability_visuals() -> void:
	for child in ability_container.get_children():
		child.queue_free()

	if not unit_stats.potion: return

	for ability in unit_stats.potion.abilities:
		var ability_panel_instance := ABILITY_PANEL_SCENE.instantiate()
		ability_container.add_child(ability_panel_instance)
		ability_panel_instance.ability = ability


func _on_line_edit_text_submitted(value: String) -> void:
	unit_stats.name = value
	line_edit.clear()
	unit_created.emit(unit_stats)
