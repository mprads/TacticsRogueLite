extends Node
class_name InventoryManager

@export var run_stats: RunStats


func _ready() -> void:
	Events.request_add_item.connect(_on_request_add_item)
	Events.request_remove_item.connect(_on_request_remove_item)


func _on_request_add_item(item: Item) -> void:
	pass


func _on_request_remove_item(item: Item) -> void:
	pass
