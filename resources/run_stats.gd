extends Resource
class_name RunStats

const STARTING_GOLD := 50
const STARTING_PARTY_SIZE := 6

@export var gold := STARTING_GOLD
@export var inventory: Dictionary[ItemConfig.KEYS, int]
@export var party: Array[UnitStats]
@export var party_size := STARTING_PARTY_SIZE


func add_item_to_inventory(key: ItemConfig.KEYS) -> void:
	if not key: return
	
	if inventory.has(key):
		inventory[key] += 1
	else:
		inventory[key] = 1


func remove_item_from_inventory(key: ItemConfig.KEYS) -> void:
	if not key: return
	if not inventory.has(key): return
	
	if inventory[key] > 1:
		inventory[key] -= 1
	else:
		inventory.erase(key)
