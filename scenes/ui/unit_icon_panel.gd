class_name UnitIconPanel
extends Panel

const UNIT_ICON_PANEL_SCENE = preload("uid://i84sei2wbdf7")

@export var unit_stats: UnitStats:
	set = set_unit_stats

@onready var unit_icon: UnitIcon = %UnitIcon
@onready var name_label: Label = %NameLabel
@onready var name_panel: Panel = %NamePanel


func show_name_label() -> void:
	name_panel.show()


func set_unit_stats(value: UnitStats) -> void:
	if not is_node_ready():
		await ready

	unit_stats = value
	unit_icon.unit_stats = value

	if not unit_stats: return
	name_label.text = unit_stats.name


static func create_new(new_stats: UnitStats) -> UnitIconPanel:
	var new_unit_icon_panel := UNIT_ICON_PANEL_SCENE.instantiate()
	new_unit_icon_panel.unit_stats = new_stats
	return new_unit_icon_panel
