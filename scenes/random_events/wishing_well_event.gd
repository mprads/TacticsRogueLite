class_name WishingWellEvent
extends Node2D

@export var inventory_manager: InventoryManager : set = set_inventory_manager
@export var artifact_manager: ArtifactManager : set = set_artifact_manager
@export var reward_pool: WeightedTable
@export var large_gold_cost: int = 200
@export var small_gold_cost: int = 50
@export var button_text := "Throw %s gold into well"

@onready var throw_large_gold_button: Button = %ThrowLargeGoldButton
@onready var throw_small_gold_button: Button = %ThrowSmallGoldButton
@onready var leave_button: Button = %LeaveButton


func _ready() -> void:
	leave_button.pressed.connect(Events.random_event_exited.emit)
	throw_large_gold_button.pressed.connect(_on_gold_button_pressed.bind(large_gold_cost))
	throw_small_gold_button.pressed.connect(_on_gold_button_pressed.bind(small_gold_cost))

	throw_large_gold_button.text = button_text % large_gold_cost
	throw_small_gold_button.text = button_text % small_gold_cost

	reward_pool.setup()


func set_inventory_manager(value: InventoryManager) -> void:
	inventory_manager = value

	if not inventory_manager.gold_changed.is_connected(_on_inventory_gold_changed):
		inventory_manager.gold_changed.connect(_on_inventory_gold_changed)
		_on_inventory_gold_changed()


func set_artifact_manager(value: ArtifactManager) -> void:
	artifact_manager = value


func _on_gold_button_pressed(value: int) -> void:
	Events.request_remove_gold.emit(-value)

	if value > small_gold_cost:
		var artifact_reward: Artifact = reward_pool.get_item_in_tier(reward_pool.get_highest_tier()).reward_res
		Events.request_add_artifact.emit(artifact_reward)
	else:
		var item_reward: Item = reward_pool.get_item_in_tier(0).reward_res
		Events.request_add_item.emit(item_reward)


func _on_inventory_gold_changed() -> void:
	var player_gold := inventory_manager.get_gold()
	
	if player_gold < small_gold_cost:
		throw_large_gold_button.disabled = true
		throw_small_gold_button.disabled = true
	elif player_gold < large_gold_cost:
		throw_large_gold_button.disabled = true
		throw_small_gold_button.disabled = false
	else:
		throw_large_gold_button.disabled = false
		throw_small_gold_button.disabled = false
