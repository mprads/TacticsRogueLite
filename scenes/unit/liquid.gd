extends Sprite2D

@onready var pendulum: Marker2D = $Pendulum


func _physics_process(_delta: float) -> void:
	material.set_shader_parameter("SurfaceRotation", -pendulum.angle - global_rotation)
