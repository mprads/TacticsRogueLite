extends Node
class_name InventoryManager

signal gold_changed
signal inventory_changed

@export var run_stats: RunStats


func _ready() -> void:
	Events.request_add_item.connect(_on_request_add_item)
	Events.request_purchase_item.connect(_on_request_purchase_item)
	Events.request_remove_item.connect(_on_request_remove_item)
	Events.request_add_gold.connect(_update_gold)


func get_gold() -> int:
	return run_stats.gold


func get_inventory() -> Dictionary[ItemConfig.KEYS, int]:
	return run_stats.inventory


func _add_item(key: ItemConfig.KEYS) -> void:
	run_stats.add_item_to_inventory(key)
	inventory_changed.emit()


func _remove_item(key: ItemConfig.KEYS, count: int) -> void:
	run_stats.remove_item_from_inventory(key, count)
	inventory_changed.emit()


func _update_gold(value: int) -> void:
	run_stats.gold = clampi(run_stats.gold + value, 0, 999)
	gold_changed.emit()


func _on_request_add_item(item: Item) -> void:
	_add_item(item.key)


func _on_request_remove_item(item: Item, count: int) -> void:
	_remove_item(item.key, count)


func _on_request_purchase_item(item: Item) -> void:
	_update_gold(-item.gold_cost)
	_add_item(item.key)
