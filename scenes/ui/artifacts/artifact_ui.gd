extends TextureRect
class_name ArtifactUI

@export var artifact: Artifact : set = set_artifact


func set_artifact(value: Artifact) -> void:
	artifact = value
	texture = artifact.icon
