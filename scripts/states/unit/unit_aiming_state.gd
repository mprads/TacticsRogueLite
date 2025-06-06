class_name UnitAimingState
extends UnitState


func enter() -> void:
	unit.aim_started.emit(unit.selected_ability)


func exit() -> void:
	unit.selected_ability = null
	unit.aim_stopped.emit()


func use_ability(targets: Array[Area2D]) -> void:
	unit.selected_ability.apply_effects(targets, unit.modifier_manager)
	unit.stats.oz -= unit.selected_ability.cost
	unit.update_visuals()
	transition_requested.emit(self, UnitStateMachine.STATE.DISABLED)


func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel") or event.is_action_pressed("right_mouse"):
		unit.aim_stopped.emit()
		transition_requested.emit(self, UnitStateMachine.STATE.IDLE)
	elif event.is_action_pressed("left_mouse"):
		if unit.selectable:
			unit.unit_selected.emit(unit)


func on_ability_selected(ability: Ability) -> void:
	unit.selected_ability = ability
	unit.aim_stopped.emit()
	unit.aim_started.emit(unit.selected_ability)


func on_mouse_entered() -> void:
	unit.selectable = true


func on_mouse_exited() -> void:
	unit.selectable = false
