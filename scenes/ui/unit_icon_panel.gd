class_name UnitIconPanel
extends Panel

@export var unit_stats: UnitStats:
	set = set_unit_stats

@onready var unit_icon: UnitIcon = %UnitIcon
@onready var name_label: Label = %NameLabel
@onready var name_panel: Panel = %NamePanel


func show_name_label() -> void:
	name_panel.show()


func set_unit_stats(value: UnitStats) -> void:
	unit_stats = value
	unit_icon.unit_stats = value

	if not unit_stats: return
	name_label.text = unit_stats.name
