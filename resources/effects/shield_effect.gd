class_name ShieldEffect
extends Effect

var amount := 0


func execute(targets: Array[Area2D]) -> void:
	for target in targets:
		if not target:
			continue

		if target is Enemy or target is Unit:
			target.stats.shield += amount
			target.spawn_floating_text(
				str(amount), ColourHelper.get_colour(ColourHelper.KEYS.SHIELD)
			)
			if target is Unit:
				Events.unit_shielded.emit(target)
