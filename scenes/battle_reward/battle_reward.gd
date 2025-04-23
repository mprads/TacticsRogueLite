extends Control
class_name BattleReward

const REWARD_BUTTON = preload("res://scenes/battle_reward/reward_button.tscn")
const GOLD_ICON = preload("res://assets/icons/gold.png")

@export var battle_stats: BattleStats : set = set_battle_stats

@onready var rewards: VBoxContainer = %Rewards
@onready var continue_button: Button = %ContinueButton


func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)

	for child in rewards.get_children():
		child.queue_free()


func set_battle_stats(value: BattleStats) -> void:
	battle_stats = value
	_roll_gold_reward()
	_roll_loot_reward()


func _roll_gold_reward() -> void:
	var gold_reward := REWARD_BUTTON.instantiate()
	gold_reward.reward_icon = GOLD_ICON
	var gold = battle_stats.get_gold_reward()
	gold_reward.reward_text = "%s Gold" % gold
	rewards.add_child(gold_reward)
	gold_reward.pressed.connect(_on_gold_reward_take.bind(gold))


func _roll_loot_reward() -> void:
	var drops = battle_stats.get_drop_reward()

	for drop in drops:
		var loot_reward := REWARD_BUTTON.instantiate()
		loot_reward.reward_icon = drop.icon
		loot_reward.reward_text = drop.name
		rewards.add_child(loot_reward)
		loot_reward.pressed.connect(_on_loot_reward_take.bind(drop))


func _on_gold_reward_take(gold: int) -> void:
	Events.request_add_gold.emit(gold)


func _on_loot_reward_take(item: Item) -> void:
	Events.request_add_item.emit(item)


func _on_continue_button_pressed() -> void:
	Events.battle_reward_exited.emit()
