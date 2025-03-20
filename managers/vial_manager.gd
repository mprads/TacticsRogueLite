extends Node
class_name VialManager

signal vials_changed

@export var run_stats: RunStats


func get_vials() -> Array[Vial]:
	return run_stats.vials
