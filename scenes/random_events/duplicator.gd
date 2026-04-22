class_name Duplicator
extends Node2D

@export var party_manager: PartyManager : set = set_party_manager

@onready var source_button: Button = %SourceButton
@onready var sacrifice_button: Button = %SacrificeButton
@onready var source_unit_icon_panel: UnitIconPanel = %SourceUnitIconPanel
@onready var sacrifice_unit_icon_panel: UnitIconPanel = %SacrificeUnitIconPanel
@onready var party_ui_panel: Panel = %PartyUIPanel
@onready var party_ui: PartyUI = %PartyUI

var selected_panel: UnitIconPanel

func _ready() -> void:
	source_button.pressed.connect(_on_source_button_pressed)
	sacrifice_button.pressed.connect(_on_sacrifice_button_pressed)
	party_ui.unit_selected.connect(_on_unit_selected)


func set_party_manager(value: PartyManager) -> void:
	party_manager = value
	party_ui.party_manager = value


func _on_source_button_pressed() -> void:
	selected_panel = source_unit_icon_panel
	party_ui_panel.show()


func _on_sacrifice_button_pressed() -> void:
	selected_panel = sacrifice_unit_icon_panel
	party_ui_panel.show()


func _on_unit_selected(unit: UnitStats) -> void:
	selected_panel.unit_stats = unit
	party_ui_panel.hide()
