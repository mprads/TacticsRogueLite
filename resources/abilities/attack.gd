extends Ability

@export var base_damage := 1


func apply_effects(targets: Array[Node]) -> void:
	var damage_effect := DamageEffect.new()
	# TODO create modifier system for statuses
	damage_effect.amount = base_damage
	damage_effect.execute(targets)
