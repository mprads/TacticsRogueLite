extends UnitState
class_name UnitDeployingState

@export var drag_and_drop:DragAndDrop


func enter() -> void:
	Events.player_turn_started.connect(_on_player_turn_started)
	drag_and_drop.drag_cancelled.connect(_on_drag_cancelled)
	drag_and_drop.dropped.connect(_on_drag_dropped)
	drag_and_drop.enabled = true
	unit.selectable = false


func exit() -> void:
	drag_and_drop.drag_cancelled.disconnect(_on_drag_cancelled)
	drag_and_drop.dropped.disconnect(_on_drag_dropped)


func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		if unit.selectable:
			Events.unit_selected.emit(unit)


func on_mouse_entered() -> void:
	unit.selectable = true


func on_mouse_exited() -> void:
	unit.selectable = false


func reset_after_dragging(starting_position: Vector2) -> void:
	unit.global_position = starting_position


func _on_player_turn_started() -> void:
	transition_requested.emit(self, UnitState.STATE.IDLE)


func _on_drag_dropped(_starting_position: Vector2) -> void:
	# emit signal for battle manager to add selection ui to scene
	pass


func _on_drag_cancelled(starting_position: Vector2) -> void:
	reset_after_dragging(starting_position)
