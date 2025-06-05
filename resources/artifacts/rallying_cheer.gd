class_name RallyingCheer
extends Artifact

@export var status: Status


func init(owner: ArtifactIcon) -> void:
	artifact_icon = owner


func activate() -> void:
	var units = artifact_icon.get_tree().get_nodes_in_group("player_unit") as Array[Unit]
	var target = RNG.array_pick_random(units)

	var status_effect := StatusEffect.new()
	var status_instance := status.duplicate()
	status_effect.status = status_instance
	status_effect.execute([target])

	activated.emit()


func get_tooltip() -> String:
	return tooltip
