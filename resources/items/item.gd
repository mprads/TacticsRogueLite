class_name Item
extends Resource

@export var name: String
@export var key: ItemConfig.KEYS
@export var icon: Texture2D
@export var gold_cost := 1

@export_category("Filters")
@export var is_plant: bool = false
@export var is_loot: bool = false
