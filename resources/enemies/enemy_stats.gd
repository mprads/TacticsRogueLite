extends Stats
class_name EnemyStats

@export_category("Visuals")
@export var name: String
@export var sprite: Texture2D

@export_category("stats")
@export var movement := 1
@export var attack_range := 1

@export var ability: Ability
