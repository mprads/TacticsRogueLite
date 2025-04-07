extends UnitState
class_name UnitIdleState

@export var drag_and_drop:DragAndDrop


func enter() -> void:
	unit.ability_selected.connect(_on_ability_selected)
	drag_and_drop.drag_started.connect(_on_drag_started)
	unit.selectable = false
	
	enable_drap_and_drop()


func exit() -> void:
	unit.ability_selected.disconnect(_on_ability_selected)
	drag_and_drop.drag_started.disconnect(_on_drag_started)


func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		if unit.selectable:
			unit.request_change_active_unit.emit(unit)
			unit.unit_selected.emit(unit)


func on_mouse_entered() -> void:
	unit.selectable = true


func on_mouse_exited() -> void:
	unit.selectable = false


func disable_drag_and_drop() -> void:
	drag_and_drop.enabled = false


func enable_drap_and_drop() -> void:
	if unit.moveable:
		drag_and_drop.enabled = true


func _on_ability_selected(ability: Ability) -> void:
	unit.selected_ability = ability
	transition_requested.emit(self, UnitState.STATE.AIMING)


func _on_drag_started() -> void:
	transition_requested.emit(self, UnitState.STATE.MOVING)
