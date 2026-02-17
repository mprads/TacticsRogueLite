class_name UnitSelectButton
extends Button

const UNIT_SELECT_BUTTON_SCENE = preload("uid://cr2pf64g056g3")

@export var unit: Unit:
	set = set_unit
	
@export var index: int:
	set = set_index

@onready var move_icon: TextureRect = %MoveIcon
@onready var ability_icon: TextureRect = %AbilityIcon
@onready var unit_icon: UnitIcon = %UnitIcon

@onready var health_bar: ProgressBar = %HealthBar
@onready var shield_bar_outline: Panel = %ShieldBarOutline
@onready var shield_bar: ProgressBar = %ShieldBar
@onready var potion_bar_outline: Panel = %PotionBarOutline
@onready var potion_bar: ProgressBar = %PotionBar
@onready var keybind_label: Label = %KeybindLabel

var keycode: String = "Unassigned"
var input_map_id: String = ""


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(input_map_id):
		pressed.emit()


func set_index(value: int) -> void:
	if not is_node_ready():
		await ready

	index = value
	keycode = Utils.get_keycode_from_input_id("unit_%s" % value)
	input_map_id = "unit_%s" % value

	_update_visuals()


func set_unit(value: Unit) -> void:
	if not is_node_ready():
		await ready

	unit = value

	if not unit:
		return

	Events.player_turn_started.connect(_on_player_turn_started)
	Events.unit_died.connect(_on_unit_died)
	unit.movement_complete.connect(_on_movement_complete)
	unit.turn_complete.connect(_on_turn_complete)
	unit.stats.changed.connect(_update_visuals)

	_update_visuals()


func _update_visuals() -> void:
	keybind_label.text = "[%s]" % keycode

	if unit:
		unit_icon.unit_stats = unit.stats

		health_bar.max_value = unit.stats.max_health
		health_bar.value = unit.stats.health
		shield_bar.max_value = unit.stats.max_health
		shield_bar.value = unit.stats.shield

		shield_bar_outline.visible =  unit.stats.shield > 0

		if unit.stats.potion:
			potion_bar_outline.visible = true
			potion_bar.modulate = unit.stats.potion.color
			potion_bar.max_value = unit.stats.max_oz
			potion_bar.value = unit.stats.oz
		else:
			potion_bar_outline.visible = false


func _on_movement_complete() -> void:
	move_icon.modulate = Color("3a3a3a")


func _on_turn_complete() -> void:
	ability_icon.modulate = Color("3a3a3a")


func _on_player_turn_started() -> void:
	move_icon.modulate = Color.WHITE
	ability_icon.modulate = Color.WHITE


func _on_unit_died(dead_unit: Unit) -> void:
	if not unit == dead_unit:
		return

	queue_free()


func _on_mouse_entered() -> void:
	if not unit:
		return
	unit.on_mouse_entered()


func _on_mouse_exited() -> void:
	if not unit:
		return
	unit.on_mouse_exited()


static func create_new(new_unit: Unit, new_index: int) -> UnitSelectButton:
	var new_unit_select_button := UNIT_SELECT_BUTTON_SCENE.instantiate()
	new_unit_select_button.unit = new_unit
	new_unit_select_button.index = new_index
	return new_unit_select_button
