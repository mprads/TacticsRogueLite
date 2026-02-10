class_name StatusUI
extends GridContainer

@export var status_manager: StatusManager : set = set_status_manager


func set_status_manager(value: StatusManager) -> void:
	if not is_node_ready():
		await ready

	status_manager = value
	if not status_manager.statuses_updated.is_connected(_on_status_manager_statuses_updated):
		status_manager.statuses_updated.connect(_on_status_manager_statuses_updated)

	_update_visuals()


func _update_visuals() -> void:
	pass


func _on_status_manager_statuses_updated() -> void:
	_update_visuals()
