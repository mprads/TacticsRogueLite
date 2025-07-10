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


func _ready() -> void:
	Events.unit_died.connect(_on_temp)
	Events.enemy_died.connect(_on_temp)
	Events.player_turn_ended.connect(_on_temp)
	Events.run_stats_damage_dealt.connect(_on_temp)
	Events.run_stats_damage_taken.connect(_on_temp)
	Events.run_stats_oz_used.connect(_on_temp)
	Events.run_stats_ability_used.connect(_on_temp)
	Events.run_stats_potion_used.connect(_on_temp)


func _on_temp() -> void:
	print("run_stat event")
