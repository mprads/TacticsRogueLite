extends Resource
class_name BattleMapPool

@export var pool: Array[BattleMap]

# TODO Maybe turn this into a weighted table with tiers?
# Not sure what will feel better but for now pick a random map


func get_map() -> BattleMap:
	return RNG.array_pick_random(pool)
