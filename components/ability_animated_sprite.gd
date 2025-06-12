class_name AbilityAnimatedSprite
extends AnimatedSprite2D


func _ready() -> void:
	animation_finished.connect(_on_animation_finished)


func set_and_play(frames: SpriteFrames, animation_name: String) -> void:
	set_sprite_frames(frames)
	play(animation_name)


func clear() -> void:
	set_sprite_frames(null)


func _on_animation_finished() -> void:
	set_sprite_frames(null)
