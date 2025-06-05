extends Node

var _run_stats: RunStats = null


func change_scene(next_scene: PackedScene, run_stats: RunStats = null) -> void:
	_run_stats = run_stats
	get_tree().change_scene_to_packed(next_scene)


func get_run_stats() -> RunStats:
	return _run_stats
