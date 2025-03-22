extends Node
class_name VialManager

signal vials_changed

@export var run_stats: RunStats : set = set_run_stats


func get_vials() -> Array[Vial]:
	return run_stats.vials


func set_run_stats(value: RunStats) -> void:
	run_stats = value
	
	if not run_stats: return

	for vial in run_stats.vials:
		vial.changed.connect(vials_changed.emit)
