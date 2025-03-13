extends Control
class_name PlanterItem

@export var plant:Item : set = set_plant

@onready var plant_icon: TextureRect = $PlantIcon


func set_plant(value: Item) -> void:
	if not is_node_ready():
		await ready
	
	plant = value
	
	plant_icon.texture = plant.icon
