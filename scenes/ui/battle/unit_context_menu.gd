extends Control
class_name UnitContextMenu

@export var unit: Unit : set = set_unit

@onready var header_label: Label = %HeaderLabel
@onready var ability_container: VBoxContainer = %AbilityContainer
@onready var ability_button_1: Button = %AbilityButton1
@onready var ability_button_2: Button = %AbilityButton2
@onready var melee_button: Button = %MeleeButton
@onready var defend_button: Button = %DefendButton

@onready var header: Panel = %Header
@onready var border: Panel = %Border
@onready var header_sb: StyleBoxFlat = header.get_theme_stylebox("panel")
@onready var border_sb: StyleBoxFlat = border.get_theme_stylebox("panel")


func _input(event: InputEvent) -> void:
	if not unit: return

	if event.is_action_pressed("ability_1"):
		_on_ability_button_pressed(unit.stats.potion.abilities[0])
	elif event.is_action_pressed("ability_2"):
		_on_ability_button_pressed(unit.stats.potion.abilities[1])
	elif event.is_action_pressed("melee"):
		_on_ability_button_pressed(unit.stats.bottle.base_abilities[0])
	elif event.is_action_pressed("defend"):
		_on_ability_button_pressed(unit.stats.bottle.base_abilities[1])


func set_unit(value: Unit) -> void:
	if ability_button_1.pressed.is_connected(_on_ability_button_pressed):
		ability_button_1.pressed.disconnect(_on_ability_button_pressed)
	if ability_button_2.pressed.is_connected(_on_ability_button_pressed):
		ability_button_2.pressed.disconnect(_on_ability_button_pressed)
	if melee_button.pressed.is_connected(_on_ability_button_pressed):
		melee_button.pressed.disconnect(_on_ability_button_pressed)
	if defend_button.pressed.is_connected(_on_ability_button_pressed):
		defend_button.pressed.disconnect(_on_ability_button_pressed)

	unit = value

	if unit:
		visible = true
		_set_visuals()
	else:
		visible = false


func _set_visuals() -> void:
	header_label.text = unit.stats.name

	if unit.stats.potion:
		header_sb.bg_color = unit.stats.potion.color
		border_sb.border_color = unit.stats.potion.color
		ability_container.visible = true
		ability_button_1.pressed.connect(_on_ability_button_pressed.bind(unit.stats.potion.abilities[0]))
		var keycode_1 = Utils.get_keycode_from_input_id("ability_1")
		ability_button_1.text = unit.stats.potion.abilities[0].name + " [%s]" % keycode_1
		ability_button_1.disabled = unit.stats.oz < unit.stats.potion.abilities[0].cost
		ability_button_2.pressed.connect(_on_ability_button_pressed.bind(unit.stats.potion.abilities[1]))
		var keycode_2 = Utils.get_keycode_from_input_id("ability_2")
		ability_button_2.text = unit.stats.potion.abilities[1].name + " [%s]" % keycode_2
		ability_button_2.disabled = unit.stats.oz < unit.stats.potion.abilities[1].cost
	else:
		ability_container.visible = false
		header_sb.bg_color = Color("c7dcd0")
		border_sb.border_color = Color("c7dcd0")

	melee_button.pressed.connect(_on_ability_button_pressed.bind(unit.stats.bottle.base_abilities[0]))
	var keycode_melee = Utils.get_keycode_from_input_id("melee")
	melee_button.text = unit.stats.bottle.base_abilities[0].name + " [%s]" % keycode_melee
	defend_button.pressed.connect(_on_ability_button_pressed.bind(unit.stats.bottle.base_abilities[1]))
	var keycode_defend = Utils.get_keycode_from_input_id("defend")
	defend_button.text = unit.stats.bottle.base_abilities[1].name + " [%s]" % keycode_defend


func _on_ability_button_pressed(ability: Ability) -> void:
	unit.ability_selected.emit(ability)
