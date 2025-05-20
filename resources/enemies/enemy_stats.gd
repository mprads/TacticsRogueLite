extends Stats
class_name EnemyStats

@export_category("Visuals")
@export var name: String
@export var sprite: Texture2D

@export_category("Stats")
@export var movement := 1
@export var attack_range := 1
@export var dimensions: Vector2i

@export_category("Components")
@export var ability: Ability
@export var ai: EnemyAI
@export var scene: PackedScene = preload("res://scenes/enemy/enemy.tscn")
