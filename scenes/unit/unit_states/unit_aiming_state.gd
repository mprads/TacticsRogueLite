extends UnitState
class_name UnitAimingState


func enter() -> void:
	unit.aim_started.emit(unit.selected_ability)


func exit() -> void:
	unit.selected_ability = null
	unit.aim_stopped.emit()


func use_ability(targets: Array[Node]) -> void:
	print("%s ability on %s" % [unit.selected_ability.target,unit.stats.name])
	unit.selected_ability.apply_effects(targets)
	unit.stats.oz -= unit.selected_ability.cost
	transition_requested.emit(self, UnitState.STATE.DISABLED)


func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_mouse"):
		unit.aim_stopped.emit()
		transition_requested.emit(self, UnitState.STATE.IDLE)
	elif event.is_action_pressed("left_mouse"):
		if unit.selectable:
			unit.unit_selected.emit(unit)


func on_mouse_entered() -> void:
	unit.selectable = true


func on_mouse_exited() -> void:
	unit.selectable = false
