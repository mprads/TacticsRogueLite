class_name ArtifactManager
extends Node

signal artifacts_changed

const ARTIFACT_ACTIVATION_DELAY := 0.5

@export var floating_text_spawner: FloatingTextSpawner

@export var run_stats: RunStats:
	set = set_run_stats
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
	if not artifact_ui:
		return

	var artifact_icon_instance := ArtifactIcon.create_new(artifact)
	artifact_ui.add_child(artifact_icon_instance)
	artifact.init(artifact_icon_instance)


func activate_artifacts_by_type(type: Artifact.TYPE) -> void:
	var queue: Array[Artifact] = get_artifacts().filter(
		func(artifact: Artifact): return artifact.type == type
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


func _spawn_floating_text(text: String, colour: Color) -> void:
	if floating_text_spawner:
		floating_text_spawner.spawn_text(text, colour)


func _on_request_add_artifact(artifact: Artifact) -> void:
	if run_stats.artifacts.has(artifact):
		Events.request_add_gold.emit(floori(artifact.gold_cost / 3))
	else:
		run_stats.artifacts.append(artifact)
		var colour = ColourHelper.KEYS.DAMAGE if artifact.is_curse else ColourHelper.KEYS.DEBUFF
		_spawn_floating_text(artifact.name, ColourHelper.get_colour(colour)) 
		init_artifact(artifact)
		artifacts_changed.emit()
