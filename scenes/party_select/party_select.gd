extends Control
class_name PartySelect

const UNIT_SELECT_PANEL_SCENE = preload("res://scenes/party_select/unit_select_panel.tscn")
const UNIT_ICON_PANEL_SCENE = preload("res://scenes/ui/unit_icon_panel.tscn")
const ITEM_PANEL_SCENE = preload("res://scenes/ui/item_panel.tscn")
const OPTION_COUNT := 3

@export_category("Pools")
@export var starter_bottles: Array[Bottle]
@export var starter_potions: Array[Potion]
@export var starter_items: Array[Item]
@export var starter_artifacts: Array[Artifact]

@export_category("Ranges")
@export var vial_odds: float
@export var gold_odds: float
@export var gold_min: int
@export var gold_max: int
@export var item_quantity_min: int
@export var item_quantity_max: int

@export var run_stats: RunStats
@onready var inventory_manager: InventoryManager = $InventoryManager
@onready var party_manager: PartyManager = $PartyManager
@onready var vial_manager: VialManager = $VialManager
@onready var artifact_manager: ArtifactManager = $ArtifactManager

@onready var selection_container: HBoxContainer = %SelectionContainer
@onready var party_container: HBoxContainer = %PartyContainer
@onready var vial_container: HBoxContainer = %VialContainer
@onready var inventory_container: HBoxContainer = %InventoryContainer


func _ready() -> void:
	if not run_stats:
		run_stats = RunStats.new()
		_set_up_managers()

	_set_up_connections()
	_generate_options()


func _set_up_managers() -> void:
	inventory_manager.run_stats = run_stats
	party_manager.run_stats = run_stats
	vial_manager.run_stats = run_stats
	artifact_manager.run_stats = run_stats


func _set_up_connections() -> void:
	inventory_manager.inventory_changed.connect(_on_inventory_changed)
	inventory_manager.gold_changed.connect(_on_gold_changed)
	party_manager.party_changed.connect(_on_party_changed)
	vial_manager.vials_changed.connect(_on_vials_changed)


func _generate_options() -> void:
	for option in OPTION_COUNT:
		var unit_select_instance := UNIT_SELECT_PANEL_SCENE.instantiate()
		selection_container.add_child(unit_select_instance)
		var unit_stats := _generate_unit_stats()
		unit_select_instance.unit_stats = unit_stats
		unit_select_instance.panel_selected.connect(_on_panel_selected)

		unit_select_instance.contents = _generate_items()


func _generate_unit_stats() -> UnitStats:
	var unit_stats := UnitStats.new()
	var bottle: Bottle = RNG.array_pick_random(starter_bottles)
	var potion: Potion = RNG.array_pick_random(starter_potions)
	unit_stats.bottle = bottle
	unit_stats.potion = potion

	return unit_stats


func _generate_items() -> Array:
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

	return item_contents


func _on_panel_selected(unit_stats: UnitStats, contents: Array) -> void:
	party_manager.add_unit(unit_stats)
	
	for content in contents:
		if content.item is Item:
			inventory_manager.add_item(content.item, content.quantity)
		elif content.item is Vial:
			pass
		elif content is Artifact:
			pass
		else:
			inventory_manager.add_gold(content.quantity)


func _on_inventory_changed() -> void:
	for child in inventory_container.get_children():
		child.queue_free()

	var inventory := inventory_manager.get_inventory()

	for item in inventory:
		var item_panel_instance := ITEM_PANEL_SCENE.instantiate()
		inventory_container.add_child(item_panel_instance)
		item_panel_instance.item = ItemConfig.get_item_resource(item)
		item_panel_instance.count = inventory[item]


func _on_gold_changed() -> void:
	pass


func _on_party_changed() -> void:
	for child in party_container.get_children():
		child.queue_free()

	var party := party_manager.get_party()

	for unit_stats in party:
		var unit_panel_instance := UNIT_ICON_PANEL_SCENE.instantiate()
		party_container.add_child(unit_panel_instance)
		unit_panel_instance.unit = unit_stats


func _on_vials_changed() -> void:
	pass
