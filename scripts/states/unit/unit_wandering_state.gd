class_name UnitWanderingState
extends UnitState

func enter() -> void:
	unit.drag_and_drop.enabled = false
	unit.moveable = false
	unit.selectable = false
	
