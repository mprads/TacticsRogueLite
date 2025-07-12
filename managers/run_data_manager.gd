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
	Events.unit_died.connect(_on_unit_died)
	Events.enemy_died.connect(_on_enemy_died)
	Events.player_turn_ended.connect(_generic_increment.bind(1, "turns_taken"))
	Events.run_stats_damage_dealt.connect(_generic_increment.bind("damage_dealt"))
	Events.run_stats_damage_taken.connect(_generic_increment.bind("damage_taken"))
	Events.run_stats_ability_used.connect(_on_ability_used)
	Events.run_stats_potion_used.connect(_on_potion_used)


func get_ticks() -> void:
	print(Time.get_ticks_msec())


func _on_unit_died(unit: Unit) -> void:
	run_stats.fallen_units.append(unit.stats.name)


func _on_enemy_died(_enemy: Enemy) -> void:
	run_stats.enemies_defeated += 1


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


func _generic_increment(value: int, path: String) -> void:
	run_stats[path] += value
