class_name FloatingTextSpawner
extends Node2D

const FLOATING_TEXT_SCENE = preload("uid://cf5eeolalu6dd")

@export var vertical_offset := 8
@export var sibling_offset := 10


func spawn_text(text: String, text_color: Color) -> void:
	var text_instance := FLOATING_TEXT_SCENE.instantiate()
	add_child(text_instance)

	var total_offset := vertical_offset
	if get_child_count() > 1:
		total_offset += (get_child_count() - 1) * sibling_offset

	text_instance.global_position = global_position + (Vector2.UP * total_offset)
	text_instance.generate(text, text_color)
