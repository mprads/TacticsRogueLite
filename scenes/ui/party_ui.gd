extends VBoxContainer
class_name PartyUI

signal unit_selected(unit: UnitStats)

const PARTY_UNIT_UI = preload("res://scenes/ui/party_unit_ui.tscn")

@export var party_manager: PartyManager : set = _set_party_manager

var party: Array[UnitStats] = []


func _populate_party() -> void:
	party = party_manager.get_party()
	
	for unit_ui in get_children():
		unit_ui.queue_free()
	
	for index in party_manager.get_party_size():
		var unit_ui_instance = PARTY_UNIT_UI.instantiate()
		add_child(unit_ui_instance)
		
		if index <= party.size() - 1:
			unit_ui_instance.unit = party[index]
			unit_ui_instance.pressed.connect(_on_unit_ui_pressed.bind(party[index]))
		else:
			unit_ui_instance.unit = null


func _set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value
	
	_populate_party()


func _on_unit_ui_pressed(unit: UnitStats) -> void:
	unit_selected.emit(unit)
