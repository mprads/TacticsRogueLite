class_name UnitStateMachine
extends Node

enum STATE { IDLE, MOVING, AIMING, DISABLED, DEPLOYING }

@export var initial_state: STATE

@onready var state_debug: Label = $"../StateDebug"

var states: Dictionary[STATE, UnitState] = {}
var current_state: UnitState


func init(unit: Unit) -> void:
	Events.player_turn_started.connect(_on_player_turn_started)
	unit.ability_selected.connect(_on_ability_selected)
	unit.drag_and_drop.drag_started.connect(_on_drag_started)
	unit.movement_cancelled.connect(_on_movement_cancelled)

	states[STATE.IDLE] = UnitIdleState.new()
	states[STATE.MOVING] = UnitMovingState.new()
	states[STATE.AIMING] = UnitAimingState.new()
	states[STATE.DISABLED] = UnitDisabledState.new()
	states[STATE.DEPLOYING] = UnitDeployingState.new()

	for state in states.values():
		state.unit = unit
		state.transition_requested.connect(_on_transition_requested)

	if initial_state:
		states[initial_state].enter()
		current_state = states[initial_state]

		_update_debug_state_label()


func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)


func use_ability(targets: Array[Area2D]) -> void:
	if current_state:
		current_state.use_ability(targets)


func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()


func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()


func on_movement_complete() -> void:
	if current_state:
		current_state.on_movement_complete()


func _on_transition_requested(from: UnitState, to: STATE) -> void:
	if from != current_state:
		return

	var new_state := states[to]
	if not new_state:
		return

	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()

	_update_debug_state_label()


func _update_debug_state_label() -> void:
	state_debug.text = str(current_state.get_script().get_global_name())


func _on_player_turn_started() -> void:
	if current_state:
		current_state.on_player_turn_started()


func _on_ability_selected(ability: Ability) -> void:
	if current_state:
		current_state.on_ability_selected(ability)


func _on_drag_started() -> void:
	if current_state:
		current_state.on_drag_started()


func _on_movement_cancelled() -> void:
	if current_state:
		current_state.on_movement_cancelled()
