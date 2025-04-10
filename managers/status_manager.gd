extends Control
class_name StatusManager

const STATUS_UI = preload("res://scenes/ui/status_ui.tscn")

@export var status_owner: Node2D


func add_status(status: Status) -> void:
	var is_stacking := status.stack_type == Status.STACK_TYPE.INTENSITY
	var is_duration := status.stack_type == Status.STACK_TYPE.DURATION
	
	if not _has_status(status.id):
		var status_ui_instance := STATUS_UI.instantiate()
		add_child(status_ui_instance)
		status_ui_instance.status = status
		status_ui_instance.status.init(status_owner)
	
	if not is_duration and not is_stacking: return
	
	if is_duration:
		_get_status(status.id).duration += status.duration
	
	if is_stacking:
		_get_status(status.id).stacks += status.stacks


func _has_status(id: String) -> bool:
	for ui in get_children():
		if ui.status.id == id:
			return true
	
	return false


func _get_status(id: String) -> Status:
	for ui in get_children():
		if ui.status.id == id:
			return ui.status
	return null
