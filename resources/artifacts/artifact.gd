class_name Artifact
extends Resource

signal activated

enum TYPE { START_OF_TURN, END_OF_TURN, START_OF_COMBAT, END_OF_COMBAT, EVENT }

@export_category("Visuals")
@export var name: String
@export var id: String
@export var type: TYPE
@export var icon: Texture
@export_multiline var tooltip: String
@export var sfx_key: SFXConfig.KEYS

@export_category("Restrictions")
@export var can_appear_in_shop: bool
@export var can_be_reward: bool
@export var elite_reward: bool

@export var gold_cost := 0

var artifact_icon: ArtifactIcon


func init(_owner: ArtifactIcon) -> void:
	pass


func activate() -> void:
	pass


func get_tooltip() -> String:
	return tooltip
