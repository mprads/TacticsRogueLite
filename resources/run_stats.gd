class_name RunStats
extends Resource

const STARTING_GOLD := 50
const STARTING_PARTY_SIZE := 5
const STARTING_VIAL_COUNT := 3

@export var gold := STARTING_GOLD
@export var inventory: Dictionary[ItemConfig.KEYS, int]
@export var artifacts: Array[Artifact]
@export var party: Array[UnitStats]
@export var vials: Array[Vial]
@export_category("Limits")
@export var max_party_size := STARTING_PARTY_SIZE
@export var max_vial_count := STARTING_VIAL_COUNT
@export_category("Run Data")
@export var rng_seed: int
@export var rng_state: int
@export var total_gold := 0
@export var gold_spent := 0
@export var total_items := 0
@export var damage_dealt := 0
@export var damage_taken := 0
@export var oz_used := 0
@export var enemies_defeated := 0
@export var turns_taken := 0
@export var fallen_units: Array[String] = []
@export var ablities_used := {}
@export var potions_used := {}
@export var run_time := 0
# TODO maybe on unit track damage dealt and taken for more individuality between units


func add_item_to_inventory(key: ItemConfig.KEYS, count: int) -> void:
	if inventory.has(key):
		inventory[key] += count
	else:
		inventory[key] = count


func remove_item_from_inventory(key: ItemConfig.KEYS, count: int) -> void:
	if not inventory.has(key):
		return

	if inventory[key] > count:
		inventory[key] -= count
	else:
		inventory.erase(key)


func get_most_used(category: Dictionary) -> String:
	var most_used := ""
	var use_count := 0

	for item in category:
		if category[item] > use_count:
			most_used = item
			use_count = category[item]
	return most_used
