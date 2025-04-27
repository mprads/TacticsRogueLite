extends Artifact
class_name LastingShield

@export var shield_amount := 5


func init(owner: ArtifactIcon) -> void:
	Events.unit_shielded.connect(_on_unit_shielded)
	artifact_icon = owner


func get_tooltip() -> String:
	return tooltip


func _on_unit_shielded(unit: Unit) -> void:
	unit.stats.shield += shield_amount
	unit.spawn_floating_text(str(shield_amount), ColourHelper.get_colour(ColourHelper.KEYS.SHIELD))
	activated.emit()
