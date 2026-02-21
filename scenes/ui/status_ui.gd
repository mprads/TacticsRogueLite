class_name StatusUI
extends GridContainer

@export var status_manager: StatusManager : set = set_status_manager


func _ready() -> void:
	for child in get_children():
		child.queue_free()


func set_status_manager(value: StatusManager) -> void:
	if not is_node_ready():
		await ready

	status_manager = value
	if not status_manager.status_added.is_connected(_on_status_manager_status_added):
		status_manager.status_added.connect(_on_status_manager_status_added)


func _add_status_icon(status: Status) -> void:
	var status_icon_instance := StatusIcon.create_new(status)
	add_child(status_icon_instance)


func _on_status_manager_status_added(status: Status) -> void:
	_add_status_icon(status)
