extends UnitState
class_name UnitDeployingState


func enter() -> void:
	unit.drag_and_drop.enabled = true
	unit.selectable = false


func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		if unit.selectable:
			unit.request_change_active_unit.emit(unit)


func on_mouse_entered() -> void:
	unit.outline.material.set_shader_parameter('outline_thickness', unit.outline_thickness)
	unit.selectable = true


func on_mouse_exited() -> void:
	unit.outline.material.set_shader_parameter('outline_thickness', 0.0)
	unit.selectable = false


func on_player_turn_started() -> void:
	transition_requested.emit(self, UnitStateMachine.STATE.IDLE)
