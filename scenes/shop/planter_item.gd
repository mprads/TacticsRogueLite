extends Control
class_name PlanterItem

@export var plant:Item : set = set_plant
@export var outline_thickness: float = 1.0

@onready var plant_icon_button: TextureButton = $PlantIconButton



func _ready() -> void:
	plant_icon_button.mouse_entered.connect(_on_mouse_entered)
	plant_icon_button.mouse_exited.connect(_on_mouse_exited)
	plant_icon_button.pressed.connect(_on_harvest_plant)


func set_plant(value: Item) -> void:
	if not is_node_ready():
		await ready

	plant = value

	plant_icon_button.texture_normal = plant.icon


func _on_harvest_plant() -> void:
	plant_icon_button.queue_free()
	Events.request_add_item.emit(plant)


func _on_mouse_entered() -> void:
	plant_icon_button.material.set_shader_parameter('outline_thickness', outline_thickness)


func _on_mouse_exited() -> void:
	plant_icon_button.material.set_shader_parameter('outline_thickness', 0.0)
