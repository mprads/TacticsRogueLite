extends Resource
class_name RunStats

const STARTING_GOLD := 50
const STARTING_PARTY_SIZE := 5
const STARTING_VIAL_COUNT := 3

@export var gold := STARTING_GOLD
@export var inventory: Dictionary[ItemConfig.KEYS, int]
@export var party: Array[UnitStats]
@export var max_party_size := STARTING_PARTY_SIZE
@export var vials: Array[Vial]
@export var max_vial_count := STARTING_VIAL_COUNT


func add_item_to_inventory(key: ItemConfig.KEYS, count: int) -> void:	
	if inventory.has(key):
		inventory[key] += count
	else:
		inventory[key] = count


func remove_item_from_inventory(key: ItemConfig.KEYS, count: int) -> void:
	if not inventory.has(key): return
	
	if inventory[key] > count:
		inventory[key] -= count
	else:
		inventory.erase(key)
