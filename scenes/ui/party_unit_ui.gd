extends Button
class_name PartyUnitUI

@export var unit_stats: UnitStats : set = set_unit_stats

@onready var unit_icon_panel: UnitIconPanel = %UnitIconPanel
@onready var unit_details_panel: unit_detail_panel = %UnitDetailsPanel


func set_unit_stats(value: UnitStats) -> void:
	unit_stats = value

	if not unit_stats: return 

	unit_icon_panel.unit_stats = unit_stats
	unit_details_panel.unit_stats = unit_stats
