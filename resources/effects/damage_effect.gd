class_name DamageEffect
extends Effect

var amount := 0


func execute(targets: Array[Area2D]) -> void:
	for target in targets:
		if not target:
			continue

		if target is Enemy or target is Unit:
			target.take_damage(amount)
