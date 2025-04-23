extends Effect
class_name DamageEffect

var amount := 0


func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target: continue

		if target is Enemy or target is Unit:
			target.take_damage(amount)
