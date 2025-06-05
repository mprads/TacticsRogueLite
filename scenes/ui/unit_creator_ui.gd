class_name UnitCreatorUI
extends Control

signal unit_created(unit_stats: UnitStats)

const ABILITY_PANEL_SCENE = preload("res://scenes/ui/ability_panel.tscn")

@export var unit_stats: UnitStats:
	set = set_unit_stats

@onready var ability_container: VBoxContainer = %AbilityContainer
@onready var line_edit: LineEdit = %LineEdit

@onready var unit_details_panel: UnitDetailsPanel = %UnitDetailsPanel
@onready var unit_icon_panel: UnitIconPanel = %UnitIconPanel
@onready var bottle_ability_panel: AbilityPanel = %BottleAbilityPanel
@onready var bottle_label: Label = %BottleLabel
@onready var potion_label: Label = %PotionLabel


func _ready() -> void:
	line_edit.text_submitted.connect(_on_line_edit_text_submitted)


func set_unit_stats(value: UnitStats) -> void:
	unit_stats = value

	if not unit_stats:
		return

	unit_details_panel.unit_stats = unit_stats
	unit_icon_panel.unit_stats = unit_stats

	bottle_label.text = unit_stats.bottle.name

	if unit_stats.potion:
		potion_label.text = unit_stats.potion.name

	_update_ability_visuals()
	line_edit.grab_focus()


func _update_ability_visuals() -> void:
	for child in ability_container.get_children():
		child.queue_free()

	bottle_ability_panel.ability = unit_stats.bottle.base_abilities[0]

	if not unit_stats.potion:
		return

	for ability in unit_stats.potion.abilities:
		var ability_panel_instance := ABILITY_PANEL_SCENE.instantiate()
		ability_container.add_child(ability_panel_instance)
		ability_panel_instance.ability = ability


func _on_line_edit_text_submitted(value: String) -> void:
	unit_stats.name = value
	line_edit.clear()
	unit_created.emit(unit_stats)
