extends Node
class_name UnitState

enum STATE { IDLE, MOVING, ABILITY, DISABLED }

signal transition_requested(from: UnitState, to: STATE)

@export var state: STATE

var unit: Unit


func enter() -> void:
	pass


func exit() -> void:
	pass


func on_input(_event: InputEvent) -> void:
	pass
