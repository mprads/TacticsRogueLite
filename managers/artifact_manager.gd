extends Node
class_name ArtifactManager

const ARTIFACT_ICON = preload("res://scenes/ui/artifacts/artifact_icon.tscn")
const ARTIFACT_ACTIVATION_DELAY := 0.5

@export var run_stats: RunStats : set = set_run_stats
@export var artifact_ui: HBoxContainer


func _ready() -> void:
	Events.activate_artifacts_by_type.connect(activate_artifacts_by_type)
	Events.request_add_artifact.connect(_on_request_add_artifact)


func init_artifacts() -> void:
	for child in artifact_ui.get_children():
		child.queue_free()
	
	for artifact in get_artifacts():
		init_artifact(artifact)


func init_artifact(artifact: Artifact) -> void:
	var artifact_icon_instance := ARTIFACT_ICON.instantiate()
	artifact_ui.add_child(artifact_icon_instance)
	artifact_icon_instance.artifact = artifact
	artifact.init(artifact_icon_instance)


func activate_artifacts_by_type(type: Artifact.TYPE) -> void:
	var queue: Array[Artifact] = get_artifacts().filter(
		func(artifact: Artifact):
			return artifact.type == type
	) 

	if queue.is_empty():
		Events.artifacts_activated.emit(type)
		return

	var tween := create_tween()
	for artifact in queue:
		tween.tween_callback(artifact.activate)
		tween.tween_interval(ARTIFACT_ACTIVATION_DELAY)

	tween.finished.connect(func(): Events.artifacts_activated.emit(type))


func get_artifacts() -> Array[Artifact]:
	return run_stats.artifacts


func set_run_stats(value: RunStats) -> void:
	run_stats = value


func _on_request_add_artifact(artifact: Artifact) -> void:
	init_artifact(artifact)
	run_stats.artifacts.append(artifact)
