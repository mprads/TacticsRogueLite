extends Ability

@export var base_damage := 1
@export var status: Status
@export_range(0.0, 1.0) var status_chance: float


func apply_effects(targets: Array[Area2D], modifier_manager: ModifierManager) -> void:
	var damage_effect := DamageEffect.new()

	damage_effect.amount = modifier_manager.get_modified_value(
		base_damage, Modifier.TYPE.DAMAGE_DEALT
	)
	damage_effect.execute(targets)

	if status:
		for entity in targets:
			if RNG.instance.randf_range(0.0, 1.0) <= status_chance:
				var status_effect := StatusEffect.new()
				var status_instance := status.duplicate()
				status_effect.status = status_instance
				status_effect.execute([entity])
