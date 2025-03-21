extends Control
class_name InventoryItemUI

@export var item: Item : set = _set_item
@export var count: int : set = _set_count

@onready var item_icon: TextureRect = $Panel/ItemIcon
@onready var label: Label = $Panel/Label


func _set_item(value: Item) -> void:
	item = value
	
	item_icon.texture = item.icon 


func _set_count(value: int) -> void:
	count = value

	if count < 2:
		label.visible = false

	label.text = str(count)
