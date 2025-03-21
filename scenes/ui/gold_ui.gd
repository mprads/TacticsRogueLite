extends HBoxContainer
class_name GoldUI

@export var inventory_manager: InventoryManager : set = _set_inventory_manager

@onready var label: Label = $Label

var tween: Tween


func _ready() -> void:
	label.text = "0"


func _set_inventory_manager(value: InventoryManager) -> void:
	inventory_manager = value
	
	if not inventory_manager.gold_changed.is_connected(_update_gold):
		inventory_manager.gold_changed.connect(_update_gold)
	
	_update_gold()


func _update_gold() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	tween.tween_property(label, "text", str(inventory_manager.get_gold()), .5)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
