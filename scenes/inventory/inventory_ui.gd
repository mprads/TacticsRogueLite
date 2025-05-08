extends Control
class_name InventoryUI

const ITEM_PANEL_SCENE = preload("res://scenes/ui/item_panel.tscn")

@export var inventory_manager: InventoryManager : set = set_inventory_manager
@export var party_manager: PartyManager : set = set_party_manager

@onready var inventory_items: GridContainer = %InventoryItems
@onready var party_ui: VBoxContainer = %PartyUI

var inventory: Dictionary[ItemConfig.KEYS, int]


func _ready() -> void:
	hide()


func toggle_view() -> void:
	visible = !visible


func _update_inventory() -> void:
	inventory = inventory_manager.get_inventory()
	
	for item_ui in inventory_items.get_children():
		item_ui.queue_free()

	for item in inventory:
		var item_ui_instance = ITEM_PANEL_SCENE.instantiate()
		inventory_items.add_child(item_ui_instance)
		item_ui_instance.item = ItemConfig.get_item_resource(item)
		item_ui_instance.count = inventory[item]


func set_inventory_manager(value: InventoryManager) -> void:
	if not is_node_ready():
		await ready

	inventory_manager = value

	if not inventory_manager.inventory_changed.is_connected(_update_inventory):
		inventory_manager.inventory_changed.connect(_update_inventory)
		_update_inventory()


func set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value
	party_ui.party_manager = party_manager
