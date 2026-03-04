class_name WeightedGloves
extends Artifact

@export var damage_amount := 5


func init(owner: ArtifactIcon) -> void:
	Events.unit_melee.connect(_on_unit_melee)
	artifact_icon = owner


func get_tooltip() -> String:
	return tooltip


func _on_unit_melee(targets: Array[Area2D], modifier_manager: ModifierManager) -> void:
	var damage_effect := DamageEffect.new()

	damage_effect.amount = modifier_manager.get_modified_value(
		damage_amount, Modifier.TYPE.DAMAGE_DEALT
	)
	damage_effect.execute(targets)


	SFXPlayer.play(SFXConfig.get_audio_stream(sfx_key))
	activated.emit()
