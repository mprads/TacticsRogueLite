extends Node2D
class_name Shop

const SHOP_ITEM_SCENE = preload("res://scenes/shop/shop_item.tscn")
const SHOP_BOTTLE_SCENE = preload("res://scenes/shop/shop_bottle.tscn")
const SHOP_ARTIFACT_SCENE = preload("res://scenes/shop/shop_artifact.tscn")
const PLANTER_ITEM_SCENE = preload("res://scenes/shop/planter_item.tscn")

const ROUND_BOTTLE_RESOURCE = preload("res://resources/bottles/round_bottle.tres")

@export var shop_items: Array[Item]
@export var shop_bottles: Array[Bottle]
@export var shop_artifacts: Array[Artifact]
@export var shop_plants: Array[Item]

@export var item_count := 4
@export var bottle_count := 3
@export var artifact_count := 3
@export var plant_count := 2

@export var inventory_manager: InventoryManager : set = set_inventory_manager
@export var artifact_manager: ArtifactManager : set = set_artifact_manager
@export var party_manager: PartyManager : set = set_party_manager

@onready var item_shelf: HBoxContainer = %ItemShelf
@onready var bottle_shelf: HBoxContainer = %BottleShelf
@onready var artifact_shelf: HBoxContainer = %ArtifactShelf
@onready var planter_contents: HBoxContainer = %PlanterContents
@onready var leave_button: Button = %LeaveButton

@onready var round_bottle_cost: HBoxContainer = %RoundBottleCost
@onready var round_bottle_button: TextureButton = %RoundBottleButton
@onready var round_bottle_gold_cost: Label = %RoundBottleGoldCost

@onready var unit_creator_ui: UnitCreatorUI = %UnitCreatorUI
@onready var discard_unit_ui: DiscardUnitUI = %DiscardUnitUI


func _ready() -> void:
	leave_button.pressed.connect(Events.shop_exited.emit)
	round_bottle_button.pressed.connect(_on_bottle_request_purchase.bind(ROUND_BOTTLE_RESOURCE))
	unit_creator_ui.unit_created.connect(_on_unit_created)
	discard_unit_ui.unit_removed.connect(_on_unit_removed)

	var cleanup := [item_shelf, bottle_shelf, artifact_shelf, planter_contents]
	for section in cleanup:
		for shop_item in section.get_children():
			shop_item.queue_free()


func populate_shop() -> void:
	_generate_shop_items()
	_generate_shop_bottles()
	_generate_shop_artifacts()
	_generate_planter_items()


func _generate_shop_items() -> void:
	for index in item_count:
		var shop_item_instance := SHOP_ITEM_SCENE.instantiate()
		item_shelf.add_child(shop_item_instance)
		shop_item_instance.item = RNG.array_pick_random(shop_items)
		shop_item_instance.update(inventory_manager.get_gold())


func _generate_shop_bottles() -> void:
	for index in bottle_count:
		var shop_bottle_instance := SHOP_BOTTLE_SCENE.instantiate()
		bottle_shelf.add_child(shop_bottle_instance)
		shop_bottle_instance.bottle = RNG.array_pick_random(shop_bottles)
		shop_bottle_instance.update(inventory_manager.get_gold())
		shop_bottle_instance.request_purchase.connect(_on_bottle_request_purchase)


func _generate_shop_artifacts() -> void:
	var player_artifacts := artifact_manager.get_artifacts()
	var filtered_artifacts := shop_artifacts.duplicate()
	for artifact in player_artifacts:
		filtered_artifacts.erase(artifact)

	for index in clampi(filtered_artifacts.size(), 0, artifact_count):
		var shop_artifact_instance := SHOP_ARTIFACT_SCENE.instantiate()
		artifact_shelf.add_child(shop_artifact_instance)
		var selected_artifact = RNG.array_pick_random(filtered_artifacts)
		shop_artifact_instance.artifact = selected_artifact
		filtered_artifacts.erase(selected_artifact)
		shop_artifact_instance.update(inventory_manager.get_gold())


func _generate_planter_items() -> void:
	for index in plant_count:
		var shop_plant_instance := PLANTER_ITEM_SCENE.instantiate()
		planter_contents.add_child(shop_plant_instance)
		shop_plant_instance.plant = RNG.array_pick_random(shop_plants)


func set_inventory_manager(value: InventoryManager) -> void:
	inventory_manager = value

	if not inventory_manager.gold_changed.is_connected(_on_inventory_gold_changed):
		inventory_manager.gold_changed.connect(_on_inventory_gold_changed)
		_on_inventory_gold_changed()


func set_artifact_manager(value: ArtifactManager) -> void:
	artifact_manager = value


func set_party_manager(value: PartyManager) -> void:
	party_manager = value
	discard_unit_ui.party_manager = party_manager


func _on_inventory_gold_changed() -> void:
	var player_gold := inventory_manager.get_gold()
	
	for shop_item in item_shelf.get_children():
		shop_item.update(player_gold)

	for shop_item in bottle_shelf.get_children():
		shop_item.update(player_gold)

	for shop_item in artifact_shelf.get_children():
		shop_item.update(player_gold)

	# TODO pull bottle box sprite off back drop and make own scene
	if ROUND_BOTTLE_RESOURCE.gold_cost > player_gold:
		round_bottle_button.disabled = true
		round_bottle_gold_cost.modulate = Color.RED
	else:
		round_bottle_button.disabled = false
		round_bottle_gold_cost.modulate = Color.WHITE


func _on_bottle_request_purchase(bottle: Bottle, clean_up_callback: Callable = func():) -> void:
	var party := party_manager.get_party()

	if party.size() < party_manager.get_max_party_size():
		var unit_stats = UnitStats.new()
		unit_stats.bottle = bottle
		unit_creator_ui.unit_stats = unit_stats
		unit_creator_ui.visible = true
		clean_up_callback.call()
	else:
		discard_unit_ui.visible = true


func _on_unit_created(unit_stats: UnitStats) -> void:
	party_manager.add_unit(unit_stats)
	unit_creator_ui.unit_stats = null
	unit_creator_ui.visible = false
	Events.request_add_gold.emit(-unit_stats.bottle.gold_cost)


func _on_unit_removed() -> void:
	discard_unit_ui.visible = false
