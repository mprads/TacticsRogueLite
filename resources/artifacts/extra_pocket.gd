class_name ExtraPocket
extends Artifact

func init(owner: ArtifactIcon) -> void:
	artifact_icon = owner

	Events.change_max_vial_count.emit(1)

	activated.emit()
