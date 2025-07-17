class_name StatsPanel
extends Panel

@export var run_stats: RunStats : set = set_stats

@onready var seed_label: Label = %SeedLabel
@onready var run_time_label: Label = %RunTimeLabel
@onready var total_gold_label: Label = %TotalGoldLabel
@onready var gold_spent_label: Label = %GoldSpentLabel
@onready var total_items_label: Label = %TotalItemsLabel
@onready var damage_dealt_label: Label = %DamageDealtLabel
@onready var damage_taken_label: Label = %DamageTakenLabel
@onready var oz_used_label: Label = %OZUsedLabel
@onready var enemies_defeated_label: Label = %EnemiesDefeatedLabel
@onready var turn_taken_label: Label = %TurnTakenLabel
@onready var fallen_units_label: Label = %FallenUnitsLabel
@onready var most_common_ability_label: Label = %MostCommonAbilityLabel
@onready var most_common_potion_label: Label = %MostCommonPotionLabel
@onready var most_damage_dealt_label: Label = %MostDamageDealtLabel
@onready var most_damage_taken_label: Label = %MostDamageTakenLabel


func set_stats(value: RunStats) -> void:
	run_stats = value

	if not run_stats:
		return 

	# TODO A smarter man would probably make the label names match the variables and
	# then loop over all the children of left and right but feels too coupled
	# for a first pass at run data
	seed_label.text += str(run_stats.rng_seed)
	run_time_label.text +=  "%s:%s" % [str(run_stats.run_time / 60), str(run_stats.run_time % 60)]
	total_gold_label.text += str(run_stats.total_gold)
	gold_spent_label.text += str(run_stats.gold_spent)
	total_items_label.text += str(run_stats.total_items)
	damage_dealt_label.text += str(run_stats.damage_dealt)
	damage_taken_label.text += str(run_stats.damage_taken)
	oz_used_label.text += str(run_stats.oz_used)
	turn_taken_label.text += str(run_stats.turns_taken)
	fallen_units_label.text += ", ".join(run_stats.fallen_units)
	most_common_ability_label.text += run_stats.get_most_used(run_stats.ablities_used)
	most_common_potion_label.text += run_stats.get_most_used(run_stats.potions_used)
	most_damage_dealt_label.text += "TBD"
	most_damage_taken_label.text += "TBD"
	
