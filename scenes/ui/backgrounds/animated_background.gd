extends Control

@export var backgrounds: Array[PackedScene]
@export var paletts: Array[CompressedTexture2D]


func _ready() -> void:
	var background: PackedScene = RNG.array_pick_random(backgrounds)
	var palette = RNG.array_pick_random(paletts)
	
	var background_instance := background.instantiate()
	add_child(background_instance)
	background_instance.material.set_shader_parameter('enable_palette_cycling', true)
	background_instance.material.set_shader_parameter('palette', palette)
