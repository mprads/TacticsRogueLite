class_name StatsPanel
extends Panel

const UNIT_ICON_PANEL = preload("uid://i84sei2wbdf7")

@export var run_stats: RunStats : set = set_stats

@onready var party_container: GridContainer = $MarginContainer/VBoxContainer/VBoxContainer/PartyContainer

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


func set_stats(value: RunStats) -> void:
	run_stats = value

	if not run_stats:
		return

	for unit_stats: UnitStats in run_stats.party:
		var new_unit_icon_panel := UNIT_ICON_PANEL.instantiate()
		party_container.add_child(new_unit_icon_panel)
		new_unit_icon_panel.unit_stats = unit_stats
		new_unit_icon_panel.show_name_label()


	# TODO A smarter man would probably make the label names match the variables and
	# then loop over all the children of left and right but feels too coupled
	# for a first pass at run data
	seed_label.text = seed_label.text % str(run_stats.rng_seed)
	run_time_label.text = run_time_label.text % Utils.format_seconds(run_stats.run_time)
	total_gold_label.text = total_gold_label.text % str(run_stats.total_gold)
	gold_spent_label.text = gold_spent_label.text % str(run_stats.gold_spent)
	total_items_label.text = total_items_label.text % str(run_stats.total_items)
	damage_dealt_label.text = damage_dealt_label.text % str(run_stats.damage_dealt)
	damage_taken_label.text = damage_taken_label.text % str(run_stats.damage_taken)
	oz_used_label.text = oz_used_label.text % str(run_stats.oz_used)
	enemies_defeated_label.text = enemies_defeated_label.text % str(run_stats.enemies_defeated)
	turn_taken_label.text = turn_taken_label.text % str(run_stats.turns_taken)
	fallen_units_label.text = fallen_units_label.text % ", ".join(run_stats.fallen_units)
	most_common_ability_label.text = most_common_ability_label.text % run_stats.get_most_used(run_stats.ablities_used)
	most_common_potion_label.text = most_common_potion_label.text % run_stats.get_most_used(run_stats.potions_used)
