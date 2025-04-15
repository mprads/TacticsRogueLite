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

	if not target.modifier_manager.get_modifier(id):
		target.modifier_manager.add_modifier(id, modifier_type, Modifier.VALUE_MODIFIER.PERCENT, value)
	
	if not changed.is_connected(_on_status_changed):
		changed.connect(_on_status_changed.bind(target.modifier_manager)) 


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


func _on_status_changed(modifier_manager: ModifierManager) -> void:
	if duration <= 0 and stack_type == STACK_TYPE.DURATION and modifier_manager:
		modifier_manager.remove_modifier(id)

	if stack_type == STACK_TYPE.INTENSITY and modifier_manager:
		modifier_manager.increase_modifier_value(id, value)
