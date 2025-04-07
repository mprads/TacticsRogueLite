extends Node
class_name UnitStateMachine

@export var initial_state: UnitState

@onready var state_debug: Label = $"../StateDebug"

var current_state: UnitState
var states: Dictionary[int, UnitState] ={}


func init(unit: Unit) -> void:
	for child in get_children():
		if child:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.unit = unit
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		
		_update_debug_state_label()


func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)


func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()


func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()


func use_ability(target: Area2D) -> void:
	if current_state:
		current_state.use_ability(target)

func _on_transition_requested(from: UnitState, to: UnitState.STATE) -> void:
	if from != current_state: return
	
	var new_state := states[to]
	if not new_state: return
	
	if current_state: current_state.exit()
	
	current_state = new_state
	current_state.enter()

	_update_debug_state_label()


func _update_debug_state_label() -> void:
	var string_state = str(current_state).split(":")
	state_debug.text = string_state[0]
