class_name RunDataManager
extends Node

@export var run_stats: RunStats

# Stats that are tracked
	#rng_seed: int
	#total_gold: int
	#gold_spent: int
	#total_items: int
	#damage_dealt: int
	#damage_taken: int
	#oz_used: int
	#enemies_defeated: int
	#turns_taken: int
	#fallen_units: Array[String]
	#ablities_used: Dictionary[String, int]
	#potions_used: Dictionary[String, int]
	#run_time: int


func _ready() -> void:
	Events.request_purchase_item.connect(_on_request_purchase)
	Events.request_purchase_bottle.connect(_on_request_purchase)
	Events.request_add_gold.connect(_generic_increment.bind("total_gold"))
	Events.request_add_item.connect(_on_add_item)
	Events.run_stats_damage_dealt.connect(_generic_increment.bind("damage_dealt"))
	Events.run_stats_damage_taken.connect(_generic_increment.bind("damage_taken"))
	Events.run_stats_ability_used.connect(_on_ability_used)
	Events.enemy_died.connect(_on_enemy_died)
	Events.player_turn_ended.connect(_generic_increment.bind(1, "turns_taken"))
	Events.unit_died.connect(_on_unit_died)
	Events.run_stats_potion_used.connect(_on_potion_used)


func set_run_time() -> void:
	var elapsed_miliseconds := _get_ticks()
	var elapsed_seconds := elapsed_miliseconds / 1000
	run_stats.run_time = elapsed_seconds


func _get_ticks() -> int:
	return Time.get_ticks_msec()


func _on_unit_died(unit: Unit) -> void:
	run_stats.fallen_units.append(unit.stats.name)


func _on_enemy_died(_enemy: Enemy) -> void:
	run_stats.enemies_defeated += 1


func _on_add_item(_item: Item) -> void:
	run_stats.total_items += 1


func _on_ability_used(ability: Ability) -> void:
	run_stats.oz_used += ability.cost
	if run_stats.ablities_used.has(ability.name):
		run_stats.ablities_used[ability.name] += 1
	else:
		run_stats.ablities_used[ability.name] = 1


func _on_potion_used(potion: Potion) -> void:
	if run_stats.potions_used.has(potion.name):
		run_stats.potions_used[potion.name] += 1
	else:
		run_stats.potions_used[potion.name] = 1


func _on_request_purchase(item: Variant) -> void:
	if not item.gold_cost:
		return
	run_stats.gold_spent += item.gold_cost


func _generic_increment(value: int, path: String) -> void:
	run_stats[path] += value
