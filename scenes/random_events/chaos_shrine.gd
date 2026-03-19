class_name ChaosShrine
extends Node2D

@export var artifact_manager: ArtifactManager : set = set_artifact_manager
@export var artifact_pool: WeightedTable
@export var curse_pool: WeightedTable

@onready var worship_button: Button = %WorshipButton
@onready var leave_button: Button = %LeaveButton


func _ready() -> void:
	worship_button.pressed.connect(_on_worship_button_pressed)
	leave_button.pressed.connect(Events.random_event_exited.emit)
	
	artifact_pool.setup()
	curse_pool.setup()


func set_artifact_manager(value: ArtifactManager) -> void:
	artifact_manager = value


func _on_worship_button_pressed() -> void:
	var artifact_reward: Artifact = artifact_pool.get_item_in_tier(0).reward_res
	Events.request_add_artifact.emit(artifact_reward)

	var curse_reward: Artifact = curse_pool.get_item_in_tier(0).reward_res
	Events.request_add_artifact.emit(curse_reward)

	Events.random_event_exited.emit
