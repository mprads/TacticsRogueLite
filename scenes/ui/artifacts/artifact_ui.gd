extends HBoxContainer
class_name ArtifactUI

signal artifacts_activated(type: Artifact.TYPE)

const ARTIFACT_ICON = preload("res://scenes/ui/artifacts/artifact_icon.tscn")
const ARTIFACT_ACTIVATION_DELAY := 0.5

@export var artifact_manager: ArtifactManager : set = set_artifact_manager


func _ready() -> void:
	Events.activate_artifacts_by_type.connect(activate_artifacts_by_type)


func activate_artifacts_by_type(type: Artifact.TYPE) -> void:
	var queue: Array[Node] = get_children().filter(
		func(artifact_icon: ArtifactIcon):
			printt(artifact_icon.artifact.type, type)
			return artifact_icon.artifact.type == type
	) 

	if queue.is_empty():
		artifacts_activated.emit(type)
		return

	var tween := create_tween()
	for artifact_icon in queue:
		tween.tween_callback(artifact_icon.artifact.activate_artifact)
		tween.tween_interval(ARTIFACT_ACTIVATION_DELAY)
	
	tween.finished.connect(func(): artifacts_activated.emit(type))

func _update_artifacts() -> void:
	for child in get_children():
		child.queue_free()

	for artifact in artifact_manager.get_artifacts():
		var artifact_icon_instance := ARTIFACT_ICON.instantiate()
		add_child(artifact_icon_instance)
		artifact_icon_instance.artifact = artifact


func set_artifact_manager(value: ArtifactManager) -> void:
	artifact_manager = value

	_update_artifacts()
