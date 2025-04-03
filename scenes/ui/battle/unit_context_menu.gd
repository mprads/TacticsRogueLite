extends Control
class_name UnitContextMenu

@export var unit: Unit : set = set_unit

@onready var header_label: Label = %HeaderLabel
@onready var ability_container: HBoxContainer = %AbilityContainer
@onready var ability_button_1: Button = %AbilityButton1
@onready var ability_button_2: Button = %AbilityButton2

@onready var header: Panel = %Header
@onready var border: Panel = %Border
@onready var header_sb: StyleBoxFlat = header.get_theme_stylebox("panel")
@onready var border_sb: StyleBoxFlat = border.get_theme_stylebox("panel")


func set_unit(value: Unit) -> void:
	if ability_button_1.pressed.is_connected(_on_ability_button_pressed):
		ability_button_1.pressed.disconnect(_on_ability_button_pressed)
	if ability_button_2.pressed.is_connected(_on_ability_button_pressed):
		ability_button_2.pressed.disconnect(_on_ability_button_pressed)

	unit = value
	
	if not unit: return
	
	_set_visuals()


func _set_visuals() -> void:
	header_label.text = unit.stats.name
	
	if unit.stats.potion:
		header_sb.bg_color = unit.stats.potion.color
		border_sb.border_color = unit.stats.potion.color
		ability_container.visible = true
		ability_button_1.text = unit.stats.potion.abilities[0].name
		ability_button_1.pressed.connect(_on_ability_button_pressed.bind(unit.stats.potion.abilities[0]))
		ability_button_2.text = unit.stats.potion.abilities[1].name
		ability_button_2.pressed.connect(_on_ability_button_pressed.bind(unit.stats.potion.abilities[1]))
	else:
		ability_container.visible = false
		header_sb.bg_color = Color("c7dcd0")
		border_sb.border_color = Color("c7dcd0")


func _on_ability_button_pressed(ability: Ability) -> void:
	unit.ability_selected.emit(ability)
