extends Ability

@export var base_shield := 10


func apply_effects(targets: Array[Node], _modifier_manager: ModifierManager) -> void:
	var shield_effect := ShieldEffect.new()
	shield_effect.amount = base_shield
	shield_effect.execute(targets)
