class_name BattleUnitUI
extends Control

signal unit_selected(unit: Unit)

const BATTLE_UNIT_UI_SCENE = preload("uid://e0teld8gsvyy")

@export var unit: Unit:
	set = set_unit

@export var index: int:
	set = set_index

@onready var unit_select_button: UnitSelectButton = %UnitSelectButton
@onready var status_ui: StatusUI = %StatusUI


func _ready() -> void:
	unit_select_button.pressed.connect(_on_unit_select_button_pressed)

	unit_select_button.index = index


func set_index(value: int) -> void:
	if not is_node_ready():
		await ready

	index = value
	unit_select_button.index = index


func set_unit(value: Unit) -> void:
	if not is_node_ready():
		await ready

	unit = value

	if not value:
		return

	unit_select_button.unit = value
	status_ui.status_manager = value.status_manager
	Events.unit_died.connect(_on_unit_died)


func _on_unit_died(dead_unit: Unit) -> void:
	if not unit == dead_unit:
		return

	queue_free()


func _on_unit_select_button_pressed() -> void:
	unit_selected.emit(unit)


static func create_new(new_unit: Unit, new_index: int) -> BattleUnitUI:
	var new_unit_battle_unit_ui := BATTLE_UNIT_UI_SCENE.instantiate()
	new_unit_battle_unit_ui.unit = new_unit
	new_unit_battle_unit_ui.index = new_index
	return new_unit_battle_unit_ui
