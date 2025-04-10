extends Ability

@export var status: Status


func apply_effects(targets: Array[Node]) -> void:
	var status_effect := StatusEffect.new()
	var status_instance := status.duplicate()
	status_effect.status = status_instance
	status_effect.execute(targets)
