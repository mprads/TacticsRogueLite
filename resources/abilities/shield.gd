extends Ability

@export var base_shield := 10


func apply_effects(targets: Array[Area2D], _modifier_manager: ModifierManager) -> void:
	_play_sfx()

	var shield_effect := ShieldEffect.new()
	shield_effect.amount = base_shield
	shield_effect.execute(targets)
