class_name UnitIdleState
extends UnitState


func enter() -> void:
	unit.selectable = false
	unit.play_animation("idle")
	enable_drap_and_drop()


func exit() -> void:
	unit.animation_player.stop()


func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		if unit.selectable:
			unit.request_change_active_unit.emit(unit)
			unit.unit_selected.emit(unit)


func on_mouse_entered() -> void:
	unit.outline.material.set_shader_parameter("outline_thickness", unit.outline_thickness)
	unit.selectable = true


func on_mouse_exited() -> void:
	unit.outline.material.set_shader_parameter("outline_thickness", 0.0)
	unit.selectable = false


func enable_drap_and_drop() -> void:
	if unit.moveable:
		unit.drag_and_drop.enabled = true


func disable_drag_and_drop() -> void:
	unit.drag_and_drop.enabled = false


func on_ability_selected(ability: Ability) -> void:
	unit.selected_ability = ability
	transition_requested.emit(self, UnitStateMachine.STATE.AIMING)


func on_drag_started() -> void:
	transition_requested.emit(self, UnitStateMachine.STATE.MOVING)
