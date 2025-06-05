class_name PartySelectionContainer
extends VBoxContainer

signal unit_selected(unit: Unit)

const UNIT_SELECT_BUTTON = preload("res://scenes/ui/battle/unit_select_button.tscn")


func create_unit_select_buttons(units: Array[Node]) -> void:
	for unit in units:
		var unit_select_instance := UNIT_SELECT_BUTTON.instantiate()
		add_child(unit_select_instance)
		unit_select_instance.pressed.connect(_on_unit_select_instance_pressed.bind(unit))
		var index = get_child_count()
		unit_select_instance.keycode = Utils.get_keycode_from_input_id("unit_%s" % index)
		unit_select_instance.input_map_id = "unit_%s" % index
		unit_select_instance.unit = unit


func _on_unit_select_instance_pressed(unit: Unit) -> void:
	unit_selected.emit(unit)
