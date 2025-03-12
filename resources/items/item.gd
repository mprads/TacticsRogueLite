extends Resource
class_name Item

@export var name: String
@export var key: ItemConfig.KEYS
@export var icon: Texture2D
@export var gold_cost := 1
@export var is_plant: bool = false
