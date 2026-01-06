class_name WeightedTable
extends Resource

@export var pool: Array[Resource]
@export var tiers := 1

var total_weights_by_tier: Array[float]


func setup() -> void:
	for tier in tiers:
		_setup_weight_for_tier(tier)


func get_item_in_tier(tier: int) -> Resource:
	var roll := RNG.instance.randf_range(0.0, total_weights_by_tier[tier])
	var items := _get_all_items_in_tier(tier)

	for item in items:
		if item.accumulated_weight > roll:
			return item

	return null


func _get_all_items_in_tier(tier: int) -> Array:
	return pool.filter(func(item): return item.tier == tier)


func _setup_weight_for_tier(tier: int) -> void:
	var items := _get_all_items_in_tier(tier)
	total_weights_by_tier.append(0.0)

	for item in items:
		total_weights_by_tier[tier] += item.weight
		item.accumulated_weight = total_weights_by_tier[tier]
