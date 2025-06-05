class_name UnitMovingState
extends UnitState


func on_mouse_exited() -> void:
	unit.selectable = false


func on_movement_complete() -> void:
	unit.moveable = false
	unit.drag_and_drop.enabled = false
	unit.movement_complete.emit()
	transition_requested.emit(self, UnitStateMachine.STATE.IDLE)


func on_movement_cancelled() -> void:
	transition_requested.emit(self, UnitStateMachine.STATE.IDLE)
