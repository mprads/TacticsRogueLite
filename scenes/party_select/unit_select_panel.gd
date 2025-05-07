extends PanelContainer
class_name UnitSelectPanel

const TEST_ROUND_UNIT = preload("res://resources/units/test_round_unit.tres")
const ABILITY_PANEL_SCENE = preload("res://scenes/ui/ability_panel.tscn")
const STARTING_ITEM_PANEL_SCENE = preload("res://scenes/party_select/starting_item_panel.tscn")
const GOLD_ICON = preload("res://assets/icons/gold.png")

@export var unit_stats: UnitStats : set = set_unit_stats
@export var content: Array : set = set_content

@onready var ability_container: HBoxContainer = %AbilityContainer
@onready var party_unit_ui: PartyUnitUI = %PartyUnitUI
@onready var contents: VBoxContainer = %Contents


func _ready() -> void:
	unit_stats = TEST_ROUND_UNIT


func _update_ability_visuals(unit_stats: UnitStats) -> void:
	for child in ability_container.get_children():
		child.queue_free()

	if not unit_stats.potion: return

	for ability in unit_stats.potion.abilities:
		var ability_panel_instance := ABILITY_PANEL_SCENE.instantiate()
		ability_container.add_child(ability_panel_instance)
		ability_panel_instance.ability = ability


func set_unit_stats(value: UnitStats) -> void:
	unit_stats = value
	party_unit_ui.unit = unit_stats

	_update_ability_visuals(unit_stats)


func set_content(value: Array) -> void:
	content = value

	for lineitem in content:
		var item_panel_instance := STARTING_ITEM_PANEL_SCENE.instantiate()
		contents.add_child(item_panel_instance)

		if lineitem.item is Item:
			item_panel_instance.get_node("%Icon").texture = lineitem.item.icon
			item_panel_instance.get_node("%ContentLabel").text = "%s %s" %[str(lineitem.quantity), lineitem.item.name]
		else:
			item_panel_instance.get_node("%Icon").texture = GOLD_ICON
			item_panel_instance.get_node("%ContentLabel").text = "%s Gold"  % str(lineitem.quantity)
