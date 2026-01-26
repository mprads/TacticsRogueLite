class_name PartySelectionContainer
extends VBoxContainer

signal unit_selected(unit: Unit)

func create_unit_select_buttons(units: Array[Node]) -> void:
	for unit in units:
		var index = get_child_count()
		var unit_select_instance := UnitSelectButton.create_new(unit, index)
		add_child(unit_select_instance)
		unit_select_instance.pressed.connect(_on_unit_select_instance_pressed.bind(unit))


func _on_unit_select_instance_pressed(unit: Unit) -> void:
	unit_selected.emit(unit)
