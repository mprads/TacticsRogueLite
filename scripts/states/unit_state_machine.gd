class_name UnitStateMachine
extends Node

enum STATE { IDLE, MOVING, AIMING, DISABLED, DEPLOYING, WANDERING }

@onready var state_debug: Label = $"../StateDebug"

var states: Dictionary[STATE, UnitState] = {}
var initial_state := STATE.DEPLOYING
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
	states[STATE.WANDERING] = UnitWanderingState.new()

	for state in states.values():
		state.unit = unit
		state.transition_requested.connect(_on_transition_requested)

	if initial_state:
		states[initial_state].enter()
		current_state = states[initial_state]

		_update_debug_state_label()


# TODO need a cleaner way to set an initial state, the init call being in
# the unit _ready prevents setting initial state before it enters the tree
func force_state_transition(next_state: STATE) -> void:
	_on_transition_requested(current_state, next_state)


func enable_drag_and_drop() -> void:
	if current_state:
		current_state.enable_drag_and_drop()


func disable_drag_and_drop() -> void:
	if current_state:
		current_state.disable_drag_and_drop()


func on_physics_process(delta: float) -> void:
	if current_state:
		current_state.on_physics_process(delta)


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
