class_name UnitDisabledState
extends UnitState


func enter() -> void:
	unit.drag_and_drop.enabled = false
	unit.disabled = true
	unit.moveable = false
	unit.selectable = false
	unit.turn_complete.emit()


func exit() -> void:
	unit.disabled = false
	unit.moveable = true




func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		if unit.selectable:
			unit.unit_selected.emit(unit)


func on_mouse_entered() -> void:
	unit.outline.material.set_shader_parameter("outline_thickness", unit.outline_thickness)
	unit.selectable = true


func on_mouse_exited() -> void:
	unit.outline.material.set_shader_parameter("outline_thickness", 0.0)
	unit.selectable = false


func on_player_turn_started() -> void:
	transition_requested.emit(self, UnitStateMachine.STATE.IDLE)
