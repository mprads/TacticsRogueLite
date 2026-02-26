class_name Ability
extends Resource

enum TYPE { ATTACK, STATUS, EFFECT }
enum TARGET {
	SELF,
	SINGLE_ALLY,
	ALL_ALLIES,
	SINGLE_ENEMY,
	ALL_ENEMIES,
	AOE_ALLY,
	AOE_ENEMY,
	AOE_ALL,
	}

@export_category("Visuals")
@export var name: String
@export var cost := 1
@export var atlas_coord: Vector2i
@export_multiline var tooltip: String
@export var sprite_frames: SpriteFrames

@export_category("Effects")
@export var type: TYPE
@export var target: TARGET
@export var shape: Array[Vector2i]
@export var max_range := 1
@export var sfx_key := SFXConfig.KEYS.MELEE_HIT


func apply_effects(_targets: Array[Area2D], _modifier_manager: ModifierManager) -> void:
	pass


func get_tooltip() -> String:
	return tooltip


func _play_sfx() -> void:
	if not sfx_key: return

	SFXPlayer.play(SFXConfig.get_audio_stream(sfx_key))
