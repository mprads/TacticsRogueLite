extends Resource
class_name Artifact

signal activated

enum TYPE { START_OF_TURN, END_OF_TURN, START_OF_COMBAT, END_OF_COMBAT, EVENT }

@export var name: String
@export var id: String
@export var type: TYPE
@export var icon: Texture
@export_multiline var tooltip: String


func activate_artifact() -> void:
	activated.emit()


func get_tooltip() -> String:
	return tooltip
