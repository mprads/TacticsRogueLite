class_name PartyDecrease
extends Artifact

func init(owner: ArtifactIcon) -> void:
	artifact_icon = owner

	Events.change_max_party_size.emit(-1)

	activated.emit()
