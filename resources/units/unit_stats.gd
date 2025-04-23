extends Stats
class_name UnitStats

@export var name := "Bottlesworth"

@export var bottle: Bottle : set = set_bottle
@export var potion: Potion : set = set_potion

@export var oz: int : set = set_oz

var movement: int
var max_oz: int


func refill(amount: int) -> void:
	oz += amount


func set_oz(value: int) -> void:
	oz = clampi(value, 0, max_oz)
	emit_changed()


func set_movement(value: int) -> void:
	movement = value


func set_bottle(value: Bottle) -> void:
	bottle = value

	max_health = bottle.base_health
	max_oz = bottle.max_oz
	movement = bottle.base_movement

	health = max_health


func set_potion(value: Potion) -> void:
	potion = value
	oz = max_oz
	emit_changed()
