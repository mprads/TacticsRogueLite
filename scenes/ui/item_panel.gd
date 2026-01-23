class_name ItemPanel
extends Control

const ITEM_PANEL = preload("uid://b8xh1jbh84qru")

@export var item: Item:
	set = set_item
@export var count: int:
	set = set_count

@onready var item_icon: TextureRect = $Panel/ItemIcon
@onready var label: Label = $Panel/Label


func set_item(value: Item) -> void:
	if not is_node_ready(): await ready

	item = value
	item_icon.texture = item.icon


func set_count(value: int) -> void:
	if not is_node_ready(): await ready

	count = value

	label.visible = count > 2
	label.text = str(count)


static func create_new(new_item: Item, new_count: int) -> ItemPanel:
	var new_item_panel := ITEM_PANEL.instantiate()
	new_item_panel.item = new_item
	new_item_panel.count = new_count
	return new_item_panel
