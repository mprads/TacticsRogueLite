extends Node2D
class_name FloatingTextSpawner

const FLOATING_TEXT_SCENE = preload("res://scenes/effects/floating_text.tscn")

@export var vertical_offset := 16

func spawn_text(text: String, text_color: Color) -> void:
	var text_instance := FLOATING_TEXT_SCENE.instantiate()
	add_child(text_instance)
	text_instance.global_position = global_position + (Vector2.UP * vertical_offset)
	text_instance.generate(text, text_color)
