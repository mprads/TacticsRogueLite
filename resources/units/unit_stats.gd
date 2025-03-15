extends Stats
class_name UnitStats

@export var potion: Potion : set = set_potion
@export var bottle: Bottle : set = set_bottle

var max_oz := 1
var oz: int : set = set_oz


func refill(amount: int) -> void:
	oz += amount


func set_oz(value : int) -> void:
	oz = clampi(value, 0, bottle.max_oz)
	emit_changed()


func set_bottle(value: Bottle) -> void:
	bottle = value
	
	max_health = bottle.base_health
	max_oz = bottle.max_oz
	
	health = max_health
	oz = max_oz


func set_potion(value: Potion) -> void:
	potion = value
