extends Control
class_name PlanterItem

@export var plant:Item : set = set_plant

@onready var plant_icon_button: TextureButton = $PlantIconButton



func _ready() -> void:
	plant_icon_button.pressed.connect(_on_harvest_plant)


func set_plant(value: Item) -> void:
	if not is_node_ready():
		await ready

	plant = value

	plant_icon_button.texture_normal = plant.icon


func _on_harvest_plant() -> void:
	plant_icon_button.queue_free()
	Events.request_add_item.emit(plant)
