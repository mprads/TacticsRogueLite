class_name RestArea
extends Node2D

const UNIT_SCENE = preload("uid://bpkwnxxboplpn")
const RANDOM_OFFSET := 48

@export var party_manager: PartyManager : set = set_party_manager

@onready var kiln_button: Button = %KilnButton
@onready var brewing_button: Button = %BrewingButton


func set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value
	_add_party_to_scene()


func _add_party_to_scene() -> void:
	for unit_stats in party_manager.get_party():
		var new_unit := UNIT_SCENE.instantiate()
		add_child(new_unit)
		new_unit.unit_state_machine.force_state_transition(UnitStateMachine.STATE.WANDERING)
		new_unit.stats = unit_stats
		new_unit.global_position.x = (get_viewport_rect().size.x / 2) + randi_range(-RANDOM_OFFSET, RANDOM_OFFSET)
		new_unit.global_position.y = (get_viewport_rect().size.y / 2) + randi_range(-RANDOM_OFFSET, RANDOM_OFFSET)
