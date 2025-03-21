extends Resource
class_name Stats

@export var max_health := 1
@export var health: int : set = set_health


func set_health(value : int) -> void:
	health = clampi(value, 0, max_health)
	emit_changed()


func take_damage(damage: int) -> void:
	if damage <= 0:
		return
	
	health -= damage


func heal(amount: int) -> void:
	health += amount
