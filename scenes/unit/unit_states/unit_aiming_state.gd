extends UnitState
class_name UnitAimingState


func enter() -> void:
	unit.aim_started.emit(unit.selected_ability)


func exit() -> void:
	unit.selected_ability = null
	unit.aim_stopped.emit()


func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_mouse"):
		unit.aim_stopped.emit()
		transition_requested.emit(self, UnitState.STATE.IDLE)
