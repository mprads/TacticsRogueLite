class_name Stats
extends Resource

@export var max_health := 1
@export var health: int:
	set = set_health

var shield: int:
	set = set_shield


func take_damage(damage: int) -> void:
	if damage <= 0:
		return

	var initial_damage = damage
	damage = clampi(damage - shield, 0, damage)
	shield = clampi(shield - initial_damage, 0, shield)
	health -= damage


func heal(amount: int) -> void:
	health += amount


func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	emit_changed()


func set_shield(value: int) -> void:
	shield = clampi(value, 0, max_health)
	emit_changed()
