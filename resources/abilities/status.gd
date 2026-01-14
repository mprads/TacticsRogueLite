extends Ability

@export var status: Status


func apply_effects(targets: Array[Area2D], _modifier_manager: ModifierManager) -> void:
	_play_sfx()

	var status_effect := StatusEffect.new()
	var status_instance := status.duplicate()
	status_effect.status = status_instance
	status_effect.execute(targets)
