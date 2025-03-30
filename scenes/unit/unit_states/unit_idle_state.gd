extends UnitState
class_name UnitIdleState

@export var drag_and_drop:DragAndDrop


func enter() -> void:
	drag_and_drop.drag_started.connect(_on_drag_started)
	
	if unit.moveable:
		drag_and_drop.enabled = true


func exit() -> void:
	drag_and_drop.drag_started.disconnect(_on_drag_started)


func _on_drag_started() -> void:
	transition_requested.emit(self, UnitState.STATE.MOVING)
