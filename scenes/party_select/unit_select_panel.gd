extends PanelContainer
class_name UnitSelectPanel

signal panel_selected(unit_stats: UnitStats, items: Array)

const TEST_ROUND_UNIT = preload("res://resources/units/test_round_unit.tres")
const ABILITY_PANEL_SCENE = preload("res://scenes/ui/ability_panel.tscn")
const STARTING_ITEM_PANEL_SCENE = preload("res://scenes/party_select/starting_item_panel.tscn")
const GOLD_ICON = preload("res://assets/icons/gold.png")

@export var unit_stats: UnitStats : set = set_unit_stats
@export var contents: Array : set = set_contents

@onready var ability_container: HBoxContainer = %AbilityContainer
@onready var party_unit_ui: PartyUnitUI = %PartyUnitUI
@onready var contents_container: VBoxContainer = %ContentsContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var disabled := false


func _ready() -> void:
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)
	unit_stats = TEST_ROUND_UNIT

	_play_animation("in")


func set_disabled() -> void:
	disabled = true


func play_discard() -> void:
	_play_animation("discard")


func _update_ability_visuals() -> void:
	for child in ability_container.get_children():
		child.queue_free()

	if not unit_stats.potion: return

	for ability in unit_stats.potion.abilities:
		var ability_panel_instance := ABILITY_PANEL_SCENE.instantiate()
		ability_container.add_child(ability_panel_instance)
		ability_panel_instance.ability = ability


func _play_animation(id: String) -> void:
	if disabled: return

	if animation_player.is_playing() and not animation_player.current_animation == id:
		animation_player.queue(id)
	else:
		animation_player.play(id)


func set_unit_stats(value: UnitStats) -> void:
	unit_stats = value
	party_unit_ui.unit = unit_stats

	_update_ability_visuals()


func set_contents(value: Array) -> void:
	contents = value

	for lineitem in contents:
		var item_panel_instance := STARTING_ITEM_PANEL_SCENE.instantiate()
		contents_container.add_child(item_panel_instance)

		if lineitem.item is Item:
			item_panel_instance.get_node("%Icon").texture = lineitem.item.icon
			item_panel_instance.get_node("%ContentLabel").text = "%s %s" %[str(lineitem.quantity), lineitem.item.name]
		elif lineitem.item is Vial:
			item_panel_instance.get_node("%Icon").visible = false
			item_panel_instance.get_node("%VialButton").visible = true
			item_panel_instance.get_node("%VialButton").vial = lineitem.item
			item_panel_instance.get_node("%ContentLabel").text = lineitem.item.potion.name
		else:
			item_panel_instance.get_node("%Icon").texture = GOLD_ICON
			item_panel_instance.get_node("%ContentLabel").text = "%s Gold"  % str(lineitem.quantity)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		_play_animation("selected")
		panel_selected.emit(unit_stats, contents)


func _on_mouse_entered() -> void:
	_play_animation("hover")
