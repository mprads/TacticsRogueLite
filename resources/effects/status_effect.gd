class_name StatusEffect
extends Effect

var status: Status


func execute(targets: Array[Area2D]) -> void:
	for target in targets:
		if not target:
			continue

		if target is Enemy or target is Unit:
			target.status_manager.add_status(status)
			target.spawn_floating_text(status.name, status.color)
