extends RefCounted
class_name UnitState

signal transition_requested(from: UnitState, to: UnitStateMachine.STATE)

var unit: Unit


func enter() -> void:
	pass


func exit() -> void:
	pass


func use_ability(targets: Array[Node]) -> void:
	pass


func on_input(_event: InputEvent) -> void:
	pass


func on_mouse_entered() -> void:
	pass


func on_mouse_exited() -> void:
	pass


func on_player_turn_started() -> void:
	pass


func on_ability_selected(_ability: Ability) -> void:
	pass


func on_drag_started() -> void:
	pass


func on_movement_complete() -> void:
	pass


func on_movement_cancelled() -> void:
	pass
