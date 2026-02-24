class_name LeakyTap
extends Artifact

@export var leak_amount := 2


func init(owner: ArtifactIcon) -> void:
	artifact_icon = owner


func activate() -> void:
	var units = artifact_icon.get_tree().get_nodes_in_group("player_unit") as Array[Unit]
	var filtered_units := units.filter(func(unit: Unit): return unit.stats.potion)

	if filtered_units.is_empty():
		return

	var selected_unit: Unit = RNG.array_pick_random(filtered_units)
	
	selected_unit.stats.oz -= leak_amount
	selected_unit.spawn_floating_text("-" + str(leak_amount), selected_unit.stats.potion.color)

	SFXPlayer.play(SFXConfig.get_audio_stream(sfx_key))
	activated.emit()


func get_tooltip() -> String:
	return tooltip
