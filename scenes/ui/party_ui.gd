class_name PartyUI
extends GridContainer

signal unit_selected(unit: UnitStats)

const PARTY_UNIT_UI_SCENE = preload("res://scenes/ui/party_unit_ui.tscn")

@export var party_manager: PartyManager:
	set = set_party_manager

var party: Array[UnitStats] = []


func _update_party() -> void:
	party = party_manager.get_party()

	for child in get_children():
		child.queue_free()

	for unit_stats in party:
		var unit_ui_instance = PARTY_UNIT_UI_SCENE.instantiate()
		add_child(unit_ui_instance)
		unit_ui_instance.unit_stats = unit_stats
		unit_ui_instance.pressed.connect(_on_unit_ui_pressed.bind(unit_stats))


func set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value

	if not party_manager.party_changed.is_connected(_update_party):
		party_manager.party_changed.connect(_update_party)
		_update_party()

	_update_party()


func _on_unit_ui_pressed(unit: UnitStats) -> void:
	if not unit:
		return

	unit_selected.emit(unit)
