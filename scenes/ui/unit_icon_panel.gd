class_name UnitIconPanel
extends Panel

@export var unit_stats: UnitStats:
	set = set_unit_stats

@onready var unit_icon: UnitIcon = %UnitIcon


func set_unit_stats(value: UnitStats) -> void:
	unit_stats = value
	unit_icon.unit_stats = value
