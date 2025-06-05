class_name VialManager
extends Node

signal vials_changed

@export var run_stats: RunStats:
	set = set_run_stats


func get_vials() -> Array[Vial]:
	return run_stats.vials


func add_vial(vial: Vial) -> void:
	run_stats.vials.append(vial)
	vials_changed.emit()


func set_run_stats(value: RunStats) -> void:
	run_stats = value

	if not run_stats:
		return

	for vial in run_stats.vials:
		vial.changed.connect(vials_changed.emit)
