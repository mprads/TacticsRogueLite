class_name UnitAimingState
extends UnitState


func enter() -> void:
	unit.aim_started.emit(unit.selected_ability)
	unit.aiming_ability_animated_sprite.set_and_play(unit.selected_ability.sprite_frames, "aiming")


func exit() -> void:
	unit.selected_ability = null
	unit.aiming_ability_animated_sprite.clear()
	unit.aim_stopped.emit()


func use_ability(targets: Array[Area2D]) -> void:
	unit.aiming_ability_animated_sprite.clear()
	for target in targets:
		if target is Unit or target is Enemy:
			target.face_source(unit.global_position)
			target.activate_ability_animated_sprite.set_and_play(unit.selected_ability.sprite_frames, "activate")
	unit.face_source(targets[0].global_position)
	await targets[0].activate_ability_animated_sprite.animation_finished
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
	unit.aiming_ability_animated_sprite.set_and_play(unit.selected_ability.sprite_frames, "aiming")


func on_mouse_entered() -> void:
	unit.selectable = true


func on_mouse_exited() -> void:
	unit.selectable = false
