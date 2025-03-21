extends Node
class_name PartyManager

signal party_changed

@export var run_stats: RunStats : set = _set_run_stats


func get_party() -> Array[UnitStats]:
	return run_stats.party


func get_max_party_size() -> int:
	return run_stats.max_party_size


func _set_run_stats(value: RunStats) -> void:
	run_stats = value

	if not run_stats: return
	
	for unit in run_stats.party:
		unit.changed.connect(party_changed.emit)
