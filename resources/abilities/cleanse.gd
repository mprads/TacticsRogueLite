class_name Cleanse
extends Ability


func apply_effects(targets: Array[Area2D], _modifier_manager: ModifierManager) -> void:
	for entity in targets:
		entity.status_manager.cleanse_negative_statuses()
