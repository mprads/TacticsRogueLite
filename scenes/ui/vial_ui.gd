extends HBoxContainer
class_name VialUI

const VIAL_BUTTON = preload("res://scenes/ui/vial_button.tscn")

@export var vial_manager: VialManager : set = set_vial_manager


func _update_vials() -> void:
	for child in get_children():
		child.queue_free()
		
	for vial in vial_manager.get_vials():
		var vial_button_instance := VIAL_BUTTON.instantiate()
		add_child(vial_button_instance)
		vial_button_instance.vial = vial


func set_vial_manager(value: VialManager) -> void:
	vial_manager = value
	
	if not vial_manager.vials_changed.is_connected(_update_vials):
		vial_manager.vials_changed.connect(_update_vials)
	
	_update_vials()
