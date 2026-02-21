class_name PartySelectionContainer
extends VBoxContainer

signal unit_selected(unit: Unit)


func _ready() -> void:
	for child in get_children():
		child.queue_free()


func create_battle_unit_ui(units: Array[Node]) -> void:
	for unit in units:
		var index = get_child_count()
		var battle_unit_ui_instance := BattleUnitUI.create_new(unit, index)
		add_child(battle_unit_ui_instance)
		battle_unit_ui_instance.unit_selected.connect(_on_unit_selected)


func _on_unit_selected(unit: Unit) -> void:
	unit_selected.emit(unit)
