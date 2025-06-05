class_name InventoryItemUI
extends Control

@export var item: Item:
	set = set_item
@export var count: int:
	set = set_count

@onready var item_icon: TextureRect = $Panel/ItemIcon
@onready var label: Label = $Panel/Label


func set_item(value: Item) -> void:
	item = value

	item_icon.texture = item.icon


func set_count(value: int) -> void:
	count = value

	if count < 2:
		label.visible = false

	label.text = str(count)
