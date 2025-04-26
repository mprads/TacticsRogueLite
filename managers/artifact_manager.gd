extends Node
class_name ArtifactManager

@export var run_stats: RunStats : set = set_run_stats


func get_artifacts() -> Array[Artifact]:
	return run_stats.artifacts


func set_run_stats(value: RunStats) -> void:
	run_stats = value
