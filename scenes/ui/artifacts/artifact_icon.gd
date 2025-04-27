extends TextureRect
class_name ArtifactIcon

@export var artifact: Artifact : set = set_artifact


func set_artifact(value: Artifact) -> void:
	artifact = value

	if not artifact.activated.is_connected(_on_artifact_activated):
		artifact.activated.connect(_on_artifact_activated)

	texture = artifact.icon


func _on_artifact_activated() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(1.25, 1.25), .25)
	tween.tween_property(self, "scale", Vector2(1, 1), .1)
