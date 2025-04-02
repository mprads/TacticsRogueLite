extends Node
class_name UnitState

enum STATE { IDLE, MOVING, AIMING, DISABLED, DEPLOYING }

signal transition_requested(from: UnitState, to: STATE)

@export var state: STATE

var unit: Unit


func enter() -> void:
	pass


func exit() -> void:
	pass


func on_input(_event: InputEvent) -> void:
	pass


func on_mouse_entered() -> void:
	pass


func on_mouse_exited() -> void:
	pass
