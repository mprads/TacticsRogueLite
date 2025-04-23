extends Resource
class_name BattleStatsPool

@export var pool: Array[BattleStats]

var total_weights_by_tier := [0.0, 0.0, 0.0]


func setup() -> void:
	for tier in total_weights_by_tier.size():
		_setup_weight_for_tier(tier)


func get_battle_in_tier(tier: int) -> BattleStats:
	var roll := RNG.instance.randf_range(0.0, total_weights_by_tier[tier])
	var battles := _get_all_battles_in_tier(tier)

	for battle in battles:
		if battle.accumulated_weight > roll:
			return battle

	return null


func _get_all_battles_in_tier(tier: int) -> Array[BattleStats]:
	return pool.filter(
		func(battle: BattleStats):
			return battle.tier == tier
	)


func _setup_weight_for_tier(tier: int) -> void:
	var battles := _get_all_battles_in_tier(tier)
	total_weights_by_tier[tier] = 0.0

	for battle in battles:
		total_weights_by_tier[tier] += battle.weight
		battle.accumulated_weight = total_weights_by_tier[tier]
