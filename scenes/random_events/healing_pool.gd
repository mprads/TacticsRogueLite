class_name HealingPool
extends Node2D

@export var artifact_manager: ArtifactManager : set = set_artifact_manager
@export var party_manager: PartyManager : set = set_party_manager

@onready var heal_curse_button: Button = %HealCurseButton
@onready var heal_team_button: Button = %HealTeamButton
@onready var leave_button: Button = %LeaveButton


func _ready() -> void:
	heal_curse_button.pressed.connect(_on_heal_curse_button_pressed)
	heal_team_button.pressed.connect(_on_heal_team_button_pressed)
	leave_button.pressed.connect(Events.random_event_exited.emit)


func _check_for_curse() -> void:
	var artifacts := artifact_manager.get_artifacts()

	for artifact: Artifact in artifacts:
		if artifact.is_curse:
			heal_curse_button.disabled = false
			break


func set_party_manager(value: PartyManager) -> void:
	party_manager = value


func set_artifact_manager(value: ArtifactManager) -> void:
	artifact_manager = value
	_check_for_curse()


func _on_heal_curse_button_pressed() -> void:
	var artifacts := artifact_manager.get_artifacts()
	var filtered := artifacts.filter(func(artifact): return artifact.is_curse)

	var selected: Artifact = RNG.array_pick_random(filtered)
	artifact_manager.remove_artifact(selected)
	Events.random_event_exited.emit()


func _on_heal_team_button_pressed() -> void:
	for unit: UnitStats in party_manager.get_party():
		unit.heal(999)

	Events.random_event_exited.emit()
