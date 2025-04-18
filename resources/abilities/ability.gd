extends Resource
class_name Ability

enum TYPE { ATTACK, STATUS }
enum TARGET { SELF, SINGLE_ALLY, ALL_ALLIES, SINGLE_ENEMY, ALL_ENEMIES, AOE }

@export_category("Visuals")
@export var name: String
@export var cost := 1
@export var atlas_coord: Vector2i

@export_category("Effects")
@export var type: TYPE
@export var target: TARGET
@export var shape: Array[Vector2i]
@export var max_range := 1


func apply_effects(_targets: Array[Node], _modifier_manager: ModifierManager) -> void:
	pass
