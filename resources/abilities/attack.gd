extends Ability

@export var base_damage := 1


func apply_effects(targets: Array[Node], modifier_manager: ModifierManager) -> void:
	var damage_effect := DamageEffect.new()

	damage_effect.amount = modifier_manager.get_modified_value(base_damage, Modifier.TYPE.DAMAGE_DEALT)
	damage_effect.execute(targets)
