extends Node2D

@export var party_manager: PartyManager : set = set_party_manager

@onready var party_ui: VBoxContainer = %PartyUI
@onready var kiln_unit_icon_panel: UnitIconPanel = %UnitIconPanel
@onready var heal_button: Button = %HealButton


func _ready() -> void:
	heal_button.pressed.connect(_on_heal_button_pressed)
	party_ui.unit_selected.connect(_on_party_unit_selected)


func set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value
	# TODO Ew prop drilling
	party_ui.party_manager = party_manager


func _on_heal_button_pressed() -> void:
	heal_button.disabled = true
	
	if kiln_unit_icon_panel.unit:
		kiln_unit_icon_panel.unit.heal(ceili(kiln_unit_icon_panel.unit.max_health * 0.3))
		
	Events.kiln_exited.emit()


func _on_party_unit_selected(unit: UnitStats) -> void:
	kiln_unit_icon_panel.unit = unit
