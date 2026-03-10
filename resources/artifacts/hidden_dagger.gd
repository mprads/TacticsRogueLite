class_name HiddenDagger
extends Artifact

@export var damage_reduction := 0.5


func init(owner: ArtifactIcon) -> void:
	Events.unit_used_ability.connect(_on_unit_used_ability)
	artifact_icon = owner


func get_tooltip() -> String:
	return tooltip


func _on_unit_used_ability(targets: Array[Area2D], modifier_manager: ModifierManager, ability: Ability) -> void:

	if ability.target != Ability.TARGET.SINGLE_ENEMY and ability.target != Ability.TARGET.ALL_ENEMIES:
		return

	var filtered_targets := targets.filter(func(enemy: Enemy): enemy.stats.health > 0)

	modifier_manager.add_modifier(
		StatusConfig.KEYS.HIDDEN_DAGGER_REDUCTION,
		Modifier.TYPE.DAMAGE_DEALT,
		Modifier.VALUE_MODIFIER.PERCENT,
		damage_reduction
	)

	ability.apply_effects(filtered_targets, modifier_manager)
	modifier_manager.remove_modifier(StatusConfig.KEYS.HIDDEN_DAGGER_REDUCTION)

	SFXPlayer.play(SFXConfig.get_audio_stream(sfx_key))
	activated.emit()
