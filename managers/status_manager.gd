class_name StatusManager
extends Control

signal statuses_applied(type: Status.TYPE)

const STATUS_UI = preload("res://scenes/ui/status_ui.tscn")

@export var status_owner: Node2D


func apply_statuses_by_type(type: Status.TYPE) -> void:
	var queue: Array[Status] = _get_all_statuses().filter(
		func(status: Status) -> bool: return status.type == type
	)

	if queue.is_empty():
		statuses_applied.emit(type)
		return

	for status in queue:
		status.apply(status_owner)

	statuses_applied.emit(type)


func add_status(status: Status) -> void:
	var is_stacking := status.stack_type == Status.STACK_TYPE.INTENSITY
	var is_duration := status.stack_type == Status.STACK_TYPE.DURATION

	if not _has_status(status.id):
		var status_ui_instance := STATUS_UI.instantiate()
		add_child(status_ui_instance)
		status_ui_instance.status = status
		status_ui_instance.status.init(status_owner)
		status_ui_instance.status.status_applied.connect(_on_status_applied)
		return

	if not is_duration and not is_stacking:
		return

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


func _get_all_statuses() -> Array[Status]:
	var statuses: Array[Status] = []
	for ui in get_children():
		statuses.append(ui.status)

	return statuses


func _on_status_applied(status: Status) -> void:
	if status.stack_type == Status.STACK_TYPE.DURATION:
		status.duration -= 1
