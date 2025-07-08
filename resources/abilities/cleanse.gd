class_name Cleanse
extends Ability


func apply_effects(targets: Array[Area2D], _modifier_manager: ModifierManager) -> void:
	for target in targets:
		target.status_manager.cleanse_negative_statuses()
