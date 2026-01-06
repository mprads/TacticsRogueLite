class_name WishingWellEvent
extends Node2D

@export var inventory_manager: InventoryManager : set = set_inventory_manager
@export var artifact_manager: ArtifactManager : set = set_artifact_manager
@export var large_gold_cost: int = 100
@export var small_gold_cost: int = 10

@onready var throw_large_gold_button: Button = %ThrowLargeGoldButton
@onready var throw_small_gold_button: Button = %ThrowSmallGoldButton
@onready var leave_button: Button = %LeaveButton


func _ready() -> void:
	leave_button.pressed.connect(Events.random_event_exited.emit)
	throw_large_gold_button.pressed.connect(_on_gold_button_pressed.bind(large_gold_cost))
	throw_small_gold_button.pressed.connect(_on_gold_button_pressed.bind(small_gold_cost))


func set_inventory_manager(value: InventoryManager) -> void:
	inventory_manager = value

	if not inventory_manager.gold_changed.is_connected(_on_inventory_gold_changed):
		inventory_manager.gold_changed.connect(_on_inventory_gold_changed)
		_on_inventory_gold_changed()	


func set_artifact_manager(value: ArtifactManager) -> void:
	artifact_manager = value


func _on_gold_button_pressed(value: int) -> void:
	pass


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
