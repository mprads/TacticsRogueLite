class_name StatsPanel
extends Panel

@export var run_stats: RunStats

@onready var seed_label: Label = %SeedLabel
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
@onready var most_damage_dealth_label: Label = %MostDamageDealthLabel
@onready var most_damage_taken_label: Label = %MostDamageTakenLabel
