class_name BattleStats
extends Resource

@export_range(0, 2) var tier: int
@export_range(0.0, 10.0) var weight: float
@export var min_gold_reward: int
@export var max_gold_reward: int
@export var max_drops := 1
@export var enemy_drops: Array[Item]
@export var enemies: Array[EnemyStats]
@export var artifact_drop: Array[Artifact]
@export var unique_map: BattleMap
@export var is_elite: bool

var accumulated_weight := 0.0


func get_gold_reward() -> int:
	return RNG.instance.randi_range(min_gold_reward, max_gold_reward)


func get_drop_reward() -> Array[Item]:
	var drops: Array[Item] = []
	for roll in RNG.instance.randi_range(1, max_drops):
		drops.append(RNG.array_pick_random(enemy_drops))

	return drops


func get_artifact_reward() -> Artifact:
	if artifact_drop.is_empty():
		return null

	return RNG.array_pick_random(artifact_drop)
