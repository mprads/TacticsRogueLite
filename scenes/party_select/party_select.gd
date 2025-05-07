extends Control
class_name PartySelect

const UNIT_SELECT_PANEL = preload("res://scenes/party_select/unit_select_panel.tscn")
const OPTION_COUNT := 3

@export_category("Pools")
@export var starter_bottles: Array[Bottle]
@export var starter_potions: Array[Potion]
@export var starter_items: Array[Item]
@export var starter_artifacts: Array[Artifact]

@export_category("Ranges")
@export var gold_odds: float
@export var gold_min: int
@export var gold_max: int
@export var item_quantity_min: int
@export var item_quantity_max: int

@onready var selection_container: HBoxContainer = %SelectionContainer


func _ready() -> void:
	for option in OPTION_COUNT:
		var unit_select_instance := UNIT_SELECT_PANEL.instantiate()
		selection_container.add_child(unit_select_instance)
		var unit_stats := _generate_unit_stats()
		unit_select_instance.unit_stats = unit_stats

		var item_contents := []

		for item in OPTION_COUNT:
			var chance := randf_range(0.0, 1.0)

			if chance > gold_odds:
				var starter_item: Item = RNG.array_pick_random(starter_items)
				var quantity := RNG.instance.randi_range(item_quantity_min, item_quantity_max)
				item_contents.append({ "item": starter_item, "quantity": quantity })
			else:
				var gold_value := RNG.instance.randi_range(gold_min, gold_max)
				item_contents.append({ "item": "gold", "quantity": gold_value })

		unit_select_instance.content = item_contents


func _generate_unit_stats() -> UnitStats:
	var unit_stats := UnitStats.new()
	var bottle: Bottle = RNG.array_pick_random(starter_bottles)
	var potion: Potion = RNG.array_pick_random(starter_potions)
	unit_stats.bottle = bottle
	unit_stats.potion = potion

	return unit_stats
