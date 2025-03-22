extends Button
class_name PartyUnitUI

@export var unit: UnitStats : set = set_unit

@onready var unit_icon_panel: UnitIconPanel = %UnitIconPanel
@onready var label: Label = %Label


func set_unit(value: UnitStats) -> void:
	unit = value
	
	if not unit: return 
	
	if not unit.changed.is_connected(_set_details):
		unit.changed.connect(_set_details)
	
	unit_icon_panel.unit = unit
	_set_details()


func _set_details() -> void:
	if unit:
		var string = "HP: %s / %s \nOZ: %s / %s"
		label.text =  string % [str(unit.health), str(unit.max_health), str(unit.oz), str(unit.max_oz)]
