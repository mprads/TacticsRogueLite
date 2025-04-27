extends Artifact
class_name NeverEndingDrip

@export var refill_amount := 2


func init(owner: ArtifactIcon) -> void:
	artifact_icon = owner


func activate() -> void:
	var units = artifact_icon.get_tree().get_nodes_in_group("player_unit") as Array[Unit]

	for unit in units:
		if not unit.stats.potion: return

		unit.stats.oz += refill_amount
		unit.spawn_floating_text(str(refill_amount), unit.stats.potion.color)

	activated.emit()


func get_tooltip() -> String:
	return tooltip
