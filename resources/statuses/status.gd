extends Resource
class_name Status

signal status_applied(status: Status)

enum TYPE { START_OF_TURN, END_OF_TURN }
enum STACK_TYPE { NONE, INTENSITY, DURATION }

@export var id: String
@export var name: String
@export var type: TYPE
@export var stack_type: STACK_TYPE
@export var duration: int : set = set_duration
@export var stacks: int : set = set_stacks
@export var modifier_type: Modifier.TYPE
@export var value: float

@export_category("Visuals")
@export var icon: Texture2D
@export_multiline var tooltip: String


func init(target: Node) -> void:
	assert(target.get("modifier_manager"), "No modifier manager on %s" % target)
	
	target.modifier_manager.add_modifier(id, type, Modifier.VALUE_MODIFIER.PERCENT, value)


func apply(_target: Node) -> void:
	status_applied.emit(self)


func get_tooltip(_target: Node) -> String:
	return tooltip


func set_duration(value: int) -> void:
	duration = value
	emit_changed()


func set_stacks(value: int) -> void:
	stacks = value
	emit_changed()
