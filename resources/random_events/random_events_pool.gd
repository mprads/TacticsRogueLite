class_name RandomEventsPool
extends Resource

@export var pool: Array[RandomEvent]

var total_weights_by_tier := [0.0, 0.0, 0.0]


func setup() -> void:
	for tier in total_weights_by_tier.size():
		_setup_weight_for_tier(tier)


func get_event_in_tier(tier: int) -> RandomEvent:
	var roll := RNG.instance.randf_range(0.0, total_weights_by_tier[tier])
	var events := _get_all_events_in_tier(tier)

	for event in events:
		if event.accumulated_weight > roll:
			return event

	return null


func _get_all_events_in_tier(tier: int) -> Array[RandomEvent]:
	return pool.filter(func(event: RandomEvent): return event.tier == tier)


func _setup_weight_for_tier(tier: int) -> void:
	var events := _get_all_events_in_tier(tier)
	total_weights_by_tier[tier] = 0.0

	for event in events:
		total_weights_by_tier[tier] += event.weight
		event.accumulated_weight = total_weights_by_tier[tier]
