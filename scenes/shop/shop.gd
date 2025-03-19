extends Node2D
class_name Shop

const SHOP_ITEM = preload("res://scenes/shop/shop_item.tscn")
const PLANTER_ITEM = preload("res://scenes/shop/planter_item.tscn")

@export var shop_items: Array[Item]
@export var shop_plants: Array[Item]

@export var item_count := 4
@export var plant_count := 2

@export var inventory_manager: InventoryManager : set = _set_inventory_manager

@onready var button: Button = $UI/VBoxContainer/Button
@onready var item_shelf: HBoxContainer = %ItemShelf
@onready var artifact_shelf: HBoxContainer = %ArtifactShelf
@onready var planter_contents: HBoxContainer = %PlanterContents


func _ready() -> void:
	button.pressed.connect(Events.shop_exited.emit)
	
	for shop_item in item_shelf.get_children():
		shop_item.queue_free()
	
	for shop_item in artifact_shelf.get_children():
		shop_item.queue_free()
		
	for shop_plant in planter_contents.get_children():
		shop_plant.queue_free()


func populate_shop() -> void:
	_generate_shop_items()
	_generate_planter_items()
	# TODO generate artifacts


func _generate_shop_items() -> void:
	for index in item_count:
		var new_shop_item := SHOP_ITEM.instantiate()
		item_shelf.add_child(new_shop_item)
		new_shop_item.item = RNG.array_pick_random(shop_items)
		new_shop_item.update(inventory_manager.get_gold())


func _generate_planter_items() -> void:
	for index in plant_count:
		var new_shop_plant := PLANTER_ITEM.instantiate()
		planter_contents.add_child(new_shop_plant)
		new_shop_plant.plant = RNG.array_pick_random(shop_plants)


func _set_inventory_manager(value: InventoryManager) -> void:
	inventory_manager = value
	
	if not inventory_manager.gold_changed.is_connected(_on_inventory_gold_changed):
		inventory_manager.gold_changed.connect(_on_inventory_gold_changed)
		_on_inventory_gold_changed()


func _on_inventory_gold_changed() -> void:
	for shop_item in item_shelf.get_children():
		shop_item.update(inventory_manager.get_gold())
