extends Area2D
class_name Unit

@export var stats: UnitStats : set = set_stats

@onready var outline: Sprite2D = $Visuals/Outline
@onready var filling: Sprite2D = $Visuals/Filling


func set_stats(value: UnitStats) -> void:
	stats = value
	
	if value == null:
		return
	
	if not is_node_ready():
		await ready
		
	stats = value

	outline.region_rect.position = Vector2(stats.bottle.sprite_coordinates) * 32
	filling.region_rect.position = Vector2(stats.bottle.sprite_coordinates) * 32
	
	if stats.potion:
		filling.modulate = stats.potion.color
