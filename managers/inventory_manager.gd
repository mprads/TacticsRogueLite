extends Node
class_name InventoryManager

signal gold_changed
signal inventory_changed

@export var run_stats: RunStats


func _ready() -> void:
	Events.request_add_item.connect(_on_request_add_item)
	Events.request_remove_item.connect(_on_request_remove_item)


func get_gold() -> int:
	return run_stats.gold


func get_inventory() -> Dictionary[ItemConfig.KEYS, int]:
	return run_stats.inventory


func _set_gold(value: int) -> void:
	run_stats.gold = clampi(run_stats.gold + value, 0, 999)
	gold_changed.emit()


func _on_request_add_item(item: Item) -> void:
	pass


func _on_request_remove_item(item: Item) -> void:
	pass
