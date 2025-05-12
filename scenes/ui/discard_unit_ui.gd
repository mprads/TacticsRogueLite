extends Control
class_name DiscardUnitUI

signal unit_removed

@export var party_manager: PartyManager : set = set_party_manager

@onready var party_ui: PartyUI = %PartyUI
@onready var cancel_label: Label = %CancelLabel


func _ready() -> void:
	party_ui.unit_selected.connect(_on_unit_selected)

	var keycode = Utils.get_keycode_from_input_id("cancel")
	cancel_label.text = "Press [%s] to cancel" % keycode


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		visible = false


func set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value
	party_ui.party_manager = party_manager


func _on_unit_selected(unit_stats: UnitStats) -> void:
	party_manager.remove_unit(unit_stats)
	unit_removed.emit()
