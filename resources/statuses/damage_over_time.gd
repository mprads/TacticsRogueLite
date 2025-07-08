class_name DamageOverTime
extends Status

@export var damage := 0


func init(target: Node) -> void:
	if not changed.is_connected(_on_status_changed):
		changed.connect(_on_status_changed.bind(target.modifier_manager))


func apply(target: Node) -> void:
	target.take_damage(damage)
	status_applied.emit(self)
