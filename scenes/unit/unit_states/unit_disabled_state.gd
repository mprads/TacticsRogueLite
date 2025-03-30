extends UnitState
class_name UnitDisabledState


func enter() -> void:
	Events.player_turn_started.connect(_on_player_turn_started)
	unit.disabled = true
	unit.turn_complete.emit()


func exit() -> void:
	Events.player_turn_started.disconnect(_on_player_turn_started)
	unit.disabled = false
	unit.moveable = true


func _on_player_turn_started() -> void:
	transition_requested.emit(self, UnitState.STATE.IDLE)
