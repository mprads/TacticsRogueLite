extends UnitState
class_name UnitIdleState

@export var drag_and_drop:DragAndDrop


func enter() -> void:
	unit.ability_selected.connect(_on_ability_selected)
	drag_and_drop.drag_started.connect(_on_drag_started)
	unit.selectable = false
	
	if unit.moveable:
		drag_and_drop.enabled = true


func exit() -> void:
	unit.ability_selected.disconnect(_on_ability_selected)
	drag_and_drop.drag_started.disconnect(_on_drag_started)


func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		if unit.selectable:
			Events.unit_selected.emit(unit)


func on_mouse_entered() -> void:
	unit.selectable = true


func on_mouse_exited() -> void:
	unit.selectable = false


func _on_ability_selected(ability: Ability) -> void:
	unit.selected_ability = ability
	transition_requested.emit(self, UnitState.STATE.AIMING)


func _on_drag_started() -> void:
	transition_requested.emit(self, UnitState.STATE.MOVING)
