class_name UnitSelectButton
extends Button

const FILLING_SHEET = preload("res://assets/sprites/potions/filling_sheet.png")
const OUTLINE_SHEET = preload("res://assets/sprites/potions/outline_sheet.png")

@export var unit: Unit:
	set = set_unit

@onready var move_icon: TextureRect = %MoveIcon
@onready var attack_icon: TextureRect = %AttackIcon

@onready var potion_icon: TextureRect = %PotionIcon
@onready var bottle_icon: TextureRect = %BottleIcon
@onready var health_bar: ProgressBar = %HealthBar
@onready var shield_bar: ProgressBar = %ShieldBar
@onready var potion_bar: ProgressBar = %PotionBar
@onready var keybind_label: Label = $KeybindLabel

var keycode: String = "Unassigned"
var input_map_id: String = ""


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(input_map_id):
		pressed.emit()


func set_unit(value: Unit) -> void:
	if not is_node_ready():
		await ready

	unit = value

	if not unit:
		return

	Events.player_turn_started.connect(_on_player_turn_started)
	Events.unit_died.connect(_on_unit_died)
	unit.movement_complete.connect(_on_movement_complete)
	unit.stats.changed.connect(_update_visuals)
	_update_visuals()


func _update_visuals() -> void:
	# TODO this is fully repeated in party unit ui, make a shared scene
	keybind_label.text = "[%s]" % keycode

	if unit:
		var coords = unit.stats.bottle.sprite_coordinates
		var sprite_size = unit.stats.bottle.sprite_size

		var outline = AtlasTexture.new()
		var filling = AtlasTexture.new()
		outline.set_atlas(OUTLINE_SHEET)
		outline.region = Rect2(
			coords[0] * sprite_size, coords[1] * sprite_size, sprite_size, sprite_size
		)
		filling.set_atlas(FILLING_SHEET)
		filling.region = Rect2(
			coords[0] * sprite_size, coords[1] * sprite_size, sprite_size, sprite_size
		)

		bottle_icon.texture = outline
		potion_icon.texture = filling

		health_bar.max_value = unit.stats.max_health
		health_bar.value = unit.stats.health
		shield_bar.max_value = unit.stats.max_health
		shield_bar.value = unit.stats.shield

		if unit.stats.potion:
			potion_icon.visible = true
			potion_icon.modulate = unit.stats.potion.color
			potion_bar.modulate = unit.stats.potion.color
			potion_bar.max_value = unit.stats.max_oz
			potion_bar.value = unit.stats.oz
		else:
			potion_icon.visible = false
			potion_bar.visible = false
	else:
		bottle_icon.texture = null
		potion_icon.texture = null


func _on_movement_complete() -> void:
	move_icon.modulate = Color("3a3a3a")


func _on_player_turn_started() -> void:
	move_icon.modulate = Color.WHITE


func _on_unit_died(dead_unit: Unit) -> void:
	if not unit == dead_unit:
		return

	queue_free()
