extends Resource
class_name RunStats

signal gold_changed
signal inventory_changed

const STARTING_GOLD := 50

@export var gold := STARTING_GOLD : set = _set_gold
@export var inventory: Dictionary[ItemConfig.KEYS, int]


func add_item_to_inventory(key: ItemConfig.KEYS) -> void:
	if not key: return
	
	if inventory.has(key):
		inventory[key] += 1
	else:
		inventory[key] = 1
	
	inventory_changed.emit()


func remove_item_from_inventory(key: ItemConfig.KEYS) -> void:
	if not key: return
	if not inventory.has(key): return
	
	if inventory[key] > 1:
		inventory[key] -= 1
	else:
		inventory.erase(key)
	
	inventory_changed.emit()


func _set_gold(value: int) -> void:
	gold = value
	gold_changed.emit()
