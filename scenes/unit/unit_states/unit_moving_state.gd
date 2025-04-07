extends UnitState
class_name UnitMovingState

@export var drag_and_drop:DragAndDrop


func enter() -> void:
	drag_and_drop.drag_cancelled.connect(_on_drag_cancelled)
	drag_and_drop.dropped.connect(_on_drag_dropped)


func exit() -> void:
	drag_and_drop.drag_cancelled.disconnect(_on_drag_cancelled)
	drag_and_drop.dropped.disconnect(_on_drag_dropped)


func on_mouse_exited() -> void:
	unit.selectable = false


func reset_after_dragging(starting_position: Vector2) -> void:
	unit.global_position = starting_position


func _on_drag_dropped(starting_position: Vector2) -> void:
	if starting_position != unit.global_position:
		unit.moveable = false
		drag_and_drop.enabled = false
		unit.movement_complete.emit()
		transition_requested.emit(self, UnitState.STATE.DISABLED)
	else:
		transition_requested.emit(self, UnitState.STATE.IDLE)


func _on_drag_cancelled(starting_position: Vector2) -> void:
	reset_after_dragging(starting_position)
	transition_requested.emit(self, UnitState.STATE.IDLE)
