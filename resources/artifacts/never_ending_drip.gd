extends Artifact
class_name NeverEndingDrip


func init(owner: ArtifactIcon) -> void:
	artifact_icon = owner


func activate() -> void:
	var units = artifact_icon.get_tree().get_nodes_in_group("player_unit") as Array[Unit]
	activated.emit()


func get_tooltip() -> String:
	return tooltip
