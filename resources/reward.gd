class_name Reward
extends Resource

@export_range(0, 2) var tier: int
@export_range(0.0, 10.0) var weight: float
@export var reward_res: Resource

var accumulated_weight := 0.0
