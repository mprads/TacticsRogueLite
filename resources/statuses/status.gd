extends Resource
class_name Status

signal status_applied(status: Status)
signal status_changed

enum TYPE { START_OF_TURN, END_OF_TURN }
enum STACK_TYPE { NONE, INTENSITY, DURATION }

@export var name: String
@export var type: TYPE
@export var stack_type: STACK_TYPE
@export var duration: int : set = set_duration
@export var stacks: int : set = set_stacks

@export_category("Visuals")
@export var icon: Texture2D
@export_multiline var tooltip: String


func init(_target: Node) -> void:
	pass


func apply(_target: Node) -> void:
	status_applied.emit(self)


func get_tooltip(_target: Node) -> String:
	return tooltip


func set_duration(value: int) -> void:
	pass


func set_stacks(value: int) -> void:
	pass
