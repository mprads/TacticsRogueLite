class_name StatusManager
extends Node

signal statuses_applied(type: Status.TYPE)
signal statuses_updated

@export var status_owner: Node2D
@export var status_ui: StatusUI
@export var statuses: Dictionary[int, StatusIcon]


func apply_statuses_by_type(type: Status.TYPE) -> void:
	var queue: Array[Status] = []
	for status_icon:StatusIcon in statuses.values():
		if status_icon.status.type == type:
			queue.append(status_icon.status)

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
		var status_icon_instance := StatusIcon.create_new(status)
		status_ui.add_child(status_icon_instance)
		status_icon_instance.status.init(status_owner)

		status_icon_instance.status.status_applied.connect(_on_status_applied)
		return

	if not is_duration and not is_stacking:
		return

	if is_duration:
		_get_status(status.id).duration += status.duration

	if is_stacking:
		_get_status(status.id).stacks += status.stacks


func cleanse_negative_statuses() -> void:
	for status_icon:StatusIcon in statuses.values():
		if status_icon.status.is_negative_effect:
			status_icon.statusstatus.duration = 0
			status_icon.statusstatus.stacks = 0


func _has_status(id: String) -> bool:
	for status_id in statuses.keys():
		if status_id == id:
			return true

	return false


func _get_status(id: String) -> Status:
	for status_id in statuses.keys():
		if status_id == id:
			return statuses[status_id].status

	return null


#func _get_all_statuses() -> Array[Status]:
	#var statuses: Array[Status] = []
	#for icon in status_ui.get_children():
		#statuses.append(icon.status)
#
	#return statuses


func _on_status_applied(status: Status) -> void:
	if status.stack_type == Status.STACK_TYPE.DURATION:
		status.duration -= 1
