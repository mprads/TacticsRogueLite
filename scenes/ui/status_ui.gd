extends Control
class_name StatusUI

@export var status: Status : set = set_status

@onready var icon: TextureRect = $Icon
@onready var duration: Label = $Duration
@onready var stacks: Label = $Stacks


func set_status(value: Status) -> void:
	if not is_node_ready(): await ready
	
	status = value
	icon.texture = status.icon
	duration.visible = status.stack_type == Status.STACK_TYPE.DURATION
	stacks.visible = status.stack_type == Status.STACK_TYPE.INTENSITY
	
	if not status.changed.is_connected(_on_status_changed):
		status.changed.connect(_on_status_changed)

	_on_status_changed()


func _on_status_changed() -> void:
	if not status: return
	
	if status.stack_type == Status.STACK_TYPE.DURATION and status.duration <= 0:
		queue_free()
	
	if status.stack_type == Status.STACK_TYPE.INTENSITY and status.stacks <= 0:
		queue_free()
	
	duration.text = str(status.duration)
	stacks.text = str(status.stacks)
