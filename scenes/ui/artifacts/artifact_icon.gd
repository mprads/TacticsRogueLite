extends TextureRect
class_name ArtifactIcon

@export var artifact: Artifact : set = set_artifact


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func set_artifact(value: Artifact) -> void:
	artifact = value

	if not artifact.activated.is_connected(_on_artifact_activated):
		artifact.activated.connect(_on_artifact_activated)

	texture = artifact.icon


func _on_artifact_activated() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(1.25, 1.25), .25)
	tween.tween_property(self, "scale", Vector2(1, 1), .1)


func _on_mouse_entered() -> void:
	var main_tooltip := { "name": artifact.name, "description": artifact.get_tooltip() }
	var secondary := []

	if artifact.get("status") :
		var status_tooltip := {
			"name": artifact.status.name,
			"description": artifact.status.get_tooltip()
		}
		secondary.append(status_tooltip)

	Events.request_show_tooltip.emit(self, main_tooltip, secondary)


func _on_mouse_exited() -> void:
	Events.hide_tooltip.emit()
