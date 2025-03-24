extends Resource
class_name BattleStats

@export_range(0, 2) var tier: int
@export_range(0.0, 10.0) var weight: float
@export var min_gold_reward: int
@export var max_gold_reward: int
@export var enemy_drops: Array[Item]
@export var enemies: Array[EnemyStats]

var accumulated_weight := 0.0


func get_gold_reward() -> int:
	return RNG.instance.randi_range(min_gold_reward, max_gold_reward)
