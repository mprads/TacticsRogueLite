extends Node
class_name PartyManager

signal party_changed

@export var run_stats: RunStats


func get_party() -> Array[UnitStats]:
	return run_stats.party


func get_max_party_size() -> int:
	return run_stats.max_party_size
