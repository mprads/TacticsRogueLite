extends Resource
class_name Bottle

@export_category("Visuals")
@export var name: String
@export var sprite_coordinates: Vector2i
@export var sprite_size: int
@export var bottle_sprite: Texture2D
@export var liquid_mask: Texture2D

@export_category("Stats")
@export var base_health := 1
@export var max_oz := 1
@export var base_movement := 1
@export var base_abilities: Array[Ability]

@export_category("Shop")
@export var gold_cost := 50
