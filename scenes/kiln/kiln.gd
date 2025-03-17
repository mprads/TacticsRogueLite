extends Node2D

const PARTY_UNIT_UI = preload("res://scenes/ui/party_unit_ui.tscn")

@export var party_manager: PartyManager : set = _set_party_manager

@onready var party_ui: VBoxContainer = %PartyUI
@onready var kiln_unit_icon_panel: UnitIconPanel = %UnitIconPanel
@onready var heal_button: Button = %HealButton

var party: Array[UnitStats] = []


func _ready() -> void:
	heal_button.pressed.connect(_on_heal_button_pressed)


func _populate_party() -> void:
	party = party_manager.get_party()
	
	for unit_ui in party_ui.get_children():
		unit_ui.queue_free()
	
	for index in party_manager.get_party_size():
		var unit_ui_instance = PARTY_UNIT_UI.instantiate()
		party_ui.add_child(unit_ui_instance)
		
		if index <= party.size() - 1:
			unit_ui_instance.unit = party[index]
			unit_ui_instance.mouse_entered.connect(_on_unit_ui_mouse_entered.bind(party[index]))
		else:
			unit_ui_instance.unit = null


func _set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value
	
	_populate_party()


func _on_heal_button_pressed() -> void:
	heal_button.disabled = true
	
	if kiln_unit_icon_panel.unit:
		kiln_unit_icon_panel.unit.heal(ceili(kiln_unit_icon_panel.unit.max_health * 0.3))
		
	Events.kiln_exited.emit()


func _on_unit_ui_mouse_entered(unit: UnitStats) -> void:
	kiln_unit_icon_panel.unit = unit
