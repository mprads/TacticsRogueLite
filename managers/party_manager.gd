extends Node
class_name PartyManager

signal party_changed

@export var run_stats: RunStats


func get_party() -> Array[UnitStats]:
	return run_stats.party


func get_party_size() -> int:
	return run_stats.party_size
