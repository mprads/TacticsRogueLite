class_name LastingShield
extends Artifact

@export var shield_amount := 5


func init(owner: ArtifactIcon) -> void:
	Events.unit_shielded.connect(_on_unit_shielded)
	artifact_icon = owner


func get_tooltip() -> String:
	return tooltip


func _on_unit_shielded(unit: Unit) -> void:
	# TODO this should be a shield effect but that creates infinite recursion, maybe
	# change this to a permanent status, but that that adds ui bloat.
	unit.stats.shield += shield_amount
	unit.spawn_floating_text(str(shield_amount), ColourHelper.get_colour(ColourHelper.KEYS.SHIELD))

	SFXPlayer.play(SFXConfig.get_audio_stream(sfx_key))
	activated.emit()
