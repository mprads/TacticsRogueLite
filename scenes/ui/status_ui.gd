extends Control
class_name StatusUI

@export var status: Status : set = set_status

@onready var icon: TextureRect = $Icon
@onready var duration: Label = $Duration
@onready var stacks: Label = $Stacks


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


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


func _on_mouse_entered() -> void:
	Events.request_show_tooltip.emit(status.name, status.get_tooltip(), global_position)


func _on_mouse_exited() -> void:
	Events.hide_tooltip.emit()
