class_name BattleReward
extends Control

const REWARD_BUTTON = preload("res://scenes/battle_reward/reward_button.tscn")
const GOLD_ICON = preload("res://assets/icons/gold.png")

@export var battle_stats: BattleStats:
	set = set_battle_stats

@onready var rewards: VBoxContainer = %Rewards
@onready var continue_button: Button = %ContinueButton


func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)

	for child in rewards.get_children():
		child.queue_free()


func set_battle_stats(value: BattleStats) -> void:
	if not is_node_ready():
		await ready

	battle_stats = value
	_roll_gold_reward()
	_roll_loot_reward()
	_roll_artifact_reward()


func _roll_gold_reward() -> void:
	var gold_reward := REWARD_BUTTON.instantiate()
	gold_reward.reward_icon = GOLD_ICON
	var gold = battle_stats.get_gold_reward()
	gold_reward.reward_text = "%s Gold" % gold
	rewards.add_child(gold_reward)
	gold_reward.pressed.connect(_on_gold_reward_taken.bind(gold))


func _roll_loot_reward() -> void:
	var drops = battle_stats.get_drop_reward()

	for drop in drops:
		var loot_reward := REWARD_BUTTON.instantiate()
		loot_reward.reward_icon = drop.icon
		loot_reward.reward_text = drop.name
		rewards.add_child(loot_reward)
		loot_reward.pressed.connect(_on_loot_reward_taken.bind(drop))


func _roll_artifact_reward() -> void:
	var drop = battle_stats.get_artifact_reward()

	if not drop:
		return

	var artifact_reward := REWARD_BUTTON.instantiate()
	artifact_reward.reward_icon = drop.icon
	artifact_reward.reward_text = drop.name
	rewards.add_child(artifact_reward)
	artifact_reward.pressed.connect(_on_artifact_reward_taken.bind(drop))


func _check_remaining_rewards() -> void:
	# Because the signal has to be sent before its queue_free have to check if the single
	# childed is queued for deletion or create a lambda to delay a frame
	if rewards.get_child_count() == 1 and rewards.get_child(0).is_queued_for_deletion():
		Events.battle_reward_exited.emit()
	elif rewards.get_child_count() <= 0:
		Events.battle_reward_exited.emit()


func _on_gold_reward_taken(gold: int) -> void:
	Events.request_add_gold.emit(gold)
	_check_remaining_rewards()


func _on_loot_reward_taken(item: Item) -> void:
	Events.request_add_item.emit(item)
	_check_remaining_rewards()


func _on_artifact_reward_taken(artifact: Artifact) -> void:
	Events.request_add_artifact.emit(artifact)
	_check_remaining_rewards()


func _on_continue_button_pressed() -> void:
	Events.battle_reward_exited.emit()
