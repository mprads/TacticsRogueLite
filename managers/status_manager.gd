class_name StatusManager
extends Node

signal statuses_applied(type: Status.TYPE)
signal status_added(status: Status)

@export var status_owner: Node2D
@export var statuses: Dictionary[StatusConfig.KEYS, Status]


func apply_statuses_by_type(type: Status.TYPE) -> void:
	var queue: Array[Status] = []
	for status:Status in statuses.values():
		if status.type == type:
			queue.append(status)

	if queue.is_empty():
		statuses_applied.emit(type)
		return

	for status in queue:
		status.apply(status_owner)

	statuses_applied.emit(type)


func add_status(status: Status) -> void:
	var is_stacking := status.stack_type == Status.STACK_TYPE.INTENSITY
	var is_duration := status.stack_type == Status.STACK_TYPE.DURATION

	if not has_status(status.id):
		statuses[status.id] = status
		status.init(status_owner)
		status.status_applied.connect(_on_status_applied)
		status.changed.connect(_on_status_changed.bind(status))
		status_added.emit(status)
		return

	if not is_duration and not is_stacking:
		return

	if is_duration:
		_get_status(status.id).duration += status.duration

	if is_stacking:
		_get_status(status.id).stacks += status.stacks


func has_status(id: StatusConfig.KEYS) -> bool:
	for status_id in statuses.keys():
		if status_id == id:
			return true

	return false


func cleanse_negative_statuses() -> void:
	for status:Status in statuses.values():
		if status.is_negative_effect:
			status.duration = 0
			status.stacks = 0


func _get_status(id: StatusConfig.KEYS) -> Status:
	for status_id in statuses.keys():
		if status_id == id:
			return statuses[status_id]

	return null


func _on_status_changed(status: Status) -> void:
	if (status.stack_type == Status.STACK_TYPE.DURATION and status.duration <= 0)\
	|| (status.stack_type == Status.STACK_TYPE.INTENSITY and status.stacks <= 0):

		status.status_applied.disconnect(_on_status_applied)
		status.changed.disconnect(_on_status_changed)
		statuses.erase(status.id)


func _on_status_applied(status: Status) -> void:
	if status.stack_type == Status.STACK_TYPE.DURATION:
		status.duration -= 1
