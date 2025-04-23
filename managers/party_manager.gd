extends Node
class_name PartyManager

signal party_changed

@export var run_stats: RunStats : set = set_run_stats


func _ready() -> void:
	Events.unit_died.connect(_on_unit_died)


func get_party() -> Array[UnitStats]:
	return run_stats.party


func get_max_party_size() -> int:
	return run_stats.max_party_size


func set_run_stats(value: RunStats) -> void:
	run_stats = value

	if not run_stats: return

	for unit in run_stats.party:
		unit.changed.connect(party_changed.emit)


func _on_unit_died(unit: Unit) -> void:
	run_stats.party.erase(unit.stats)
