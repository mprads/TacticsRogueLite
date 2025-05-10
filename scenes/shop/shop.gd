extends Node2D
class_name Shop

const SHOP_ITEM_SCENE = preload("res://scenes/shop/shop_item.tscn")
const SHOP_BOTTLE_SCENE = preload("res://scenes/shop/shop_bottle.tscn")
const SHOP_ARTIFACT_SCENE = preload("res://scenes/shop/shop_artifact.tscn")
const PLANTER_ITEM_SCENE = preload("res://scenes/shop/planter_item.tscn")

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

@onready var item_shelf: HBoxContainer = %ItemShelf
@onready var bottle_shelf: HBoxContainer = %BottleShelf
@onready var artifact_shelf: HBoxContainer = %ArtifactShelf
@onready var planter_contents: HBoxContainer = %PlanterContents
@onready var leave_button: Button = %LeaveButton


func _ready() -> void:
	leave_button.pressed.connect(Events.shop_exited.emit)

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


func _on_inventory_gold_changed() -> void:
	for shop_item in item_shelf.get_children():
		shop_item.update(inventory_manager.get_gold())

	for shop_item in bottle_shelf.get_children():
		shop_item.update(inventory_manager.get_gold())

	for shop_item in artifact_shelf.get_children():
		shop_item.update(inventory_manager.get_gold())
