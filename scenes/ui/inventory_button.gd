class_name InventoryButton
extends Button

@export var outline_thickness: float = 1.0

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
	material.set_shader_parameter("outline_thickness", outline_thickness)


func _on_mouse_exited() -> void:
	material.set_shader_parameter("outline_thickness", 0.0)
