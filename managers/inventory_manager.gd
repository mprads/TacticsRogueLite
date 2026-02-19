class_name InventoryManager
extends Node

signal gold_changed
signal inventory_changed

@export var run_stats: RunStats
@export var floating_text_spawner: FloatingTextSpawner


func _ready() -> void:
	Events.request_add_item.connect(_on_request_add_item)
	Events.request_purchase_item.connect(_on_request_purchase_item)
	Events.request_purchase_bottle.connect(_on_request_purchase_bottle)
	Events.request_purchase_artifact.connect(_on_request_purchase_artifact)
	Events.request_remove_item.connect(_on_request_remove_item)
	Events.request_add_gold.connect(_update_gold)
	Events.request_remove_gold.connect(_update_gold)


func get_gold() -> int:
	return run_stats.gold


func get_inventory() -> Dictionary[ItemConfig.KEYS, int]:
	return run_stats.inventory


func add_item(item: Item, count: int = 1) -> void:
	_add_item(item.key, count)


func add_gold(value: int) -> void:
	_update_gold(value)


func _add_item(key: ItemConfig.KEYS, count: int = 1) -> void:
	run_stats.add_item_to_inventory(key, count)
	var text = "+%s %s" % [count, ItemConfig.get_item_resource(key).name]
	floating_text_spawner.spawn_text(text, ColourHelper.get_colour(ColourHelper.KEYS.DEBUFF)) 
	inventory_changed.emit()


func _remove_item(key: ItemConfig.KEYS, count: int) -> void:
	run_stats.remove_item_from_inventory(key, count)
	var text = "-%s %s" % [count, ItemConfig.get_item_resource(key).name]
	floating_text_spawner.spawn_text(text, ColourHelper.get_colour(ColourHelper.KEYS.DAMAGE)) 
	inventory_changed.emit()


func _update_gold(value: int) -> void:
	run_stats.gold = clampi(run_stats.gold + value, 0, 999)
	gold_changed.emit()
	SFXPlayer.play(SFXConfig.get_audio_stream(SFXConfig.KEYS.GAIN_GOLD))


func _on_request_add_item(item: Item) -> void:
	_add_item(item.key)


func _on_request_remove_item(item: Item, count: int) -> void:
	_remove_item(item.key, count)


func _on_request_purchase_item(item: Item) -> void:
	_update_gold(-item.gold_cost)
	_add_item(item.key)


func _on_request_purchase_bottle(bottle: Bottle) -> void:
	_update_gold(-bottle.gold_cost)


func _on_request_purchase_artifact(artifact: Artifact) -> void:
	_update_gold(-artifact.gold_cost)
	Events.request_add_artifact.emit(artifact)
