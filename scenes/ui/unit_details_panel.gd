extends Panel
class_name unit_detail_panel

@export var unit_stats: UnitStats : set = set_unit_stats

@onready var health_label: Label = %HealthLabel
@onready var oz_label: Label = %OzLabel
@onready var movement_label: Label = %MovementLabel


func set_unit_stats(value: UnitStats) -> void:
	unit_stats = value

	if not unit_stats: return 

	if not unit_stats.changed.is_connected(_set_details):
		unit_stats.changed.connect(_set_details)

	_set_details()


func _set_details() -> void:
	if unit_stats:
		var health_string = "HP: %s / %s"
		var oz_string = "OZ: %s / %s"
		health_label.text = health_string % [str(unit_stats.health), str(unit_stats.max_health)]
		oz_label.text = oz_string % [str(unit_stats.oz), str(unit_stats.max_oz)]
		movement_label.text = "MOVE %s" % str(unit_stats.bottle.base_movement)
