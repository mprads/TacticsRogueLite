extends Control
class_name InventoryUI

const INVENTORY_ITEM_UI = preload("res://scenes/inventory/inventory_item_ui.tscn")
const INVENTORY_UNIT_UI = preload("res://scenes/inventory/inventory_unit_ui.tscn")

@export var inventory_manager: InventoryManager : set = _set_inventory_manager
@export var party_manager: PartyManager : set = _set_party_manager

@onready var inventory_items: GridContainer = %InventoryItems
@onready var inventory_party_ui: VBoxContainer = %InventoryPartyUI

var inventory: Dictionary[ItemConfig.KEYS, int]
var party: Array[UnitStats]


func _ready() -> void:
	hide()


func show_view() -> void:
	show()


func _update_inventory() -> void:
	inventory = inventory_manager.get_inventory()
	
	for item_ui in inventory_items.get_children():
		item_ui.queue_free()

	for item in inventory:
		var item_ui_instance = INVENTORY_ITEM_UI.instantiate()
		inventory_items.add_child(item_ui_instance)
		item_ui_instance.item = ItemConfig.get_item_resource(item)
		item_ui_instance.count = inventory[item]


func _update_party() -> void:
	party = party_manager.get_party()
	
	for unit_ui in inventory_party_ui.get_children():
		unit_ui.queue_free()
	
	for index in party_manager.get_party_size():
		var unit_ui_instance = INVENTORY_UNIT_UI.instantiate()
		inventory_party_ui.add_child(unit_ui_instance)
		
		if index <= party.size() - 1:
			unit_ui_instance.unit = party[index]
		else:
			unit_ui_instance.unit = null


func _set_inventory_manager(value: InventoryManager) -> void:
	inventory_manager = value
	
	if not inventory_manager.inventory_changed.is_connected(_update_inventory):
		inventory_manager.inventory_changed.connect(_update_inventory)
		_update_inventory()


func _set_party_manager(value: PartyManager) -> void:
	party_manager = value
	
	if not party_manager.party_changed.is_connected(_update_party):
		party_manager.party_changed.connect(_update_party)
		_update_party()
