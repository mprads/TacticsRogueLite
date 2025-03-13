extends Node2D

const SHOP_ITEM = preload("res://scenes/shop/shop_item.tscn")

@export var available_shop_items: Array[Item]

@onready var button: Button = $UI/VBoxContainer/Button
@onready var shop_contents: VBoxContainer = %ShopContents
@onready var item_shelf: HBoxContainer = %ItemShelf
@onready var artifact_shelf: HBoxContainer = %ArtifactShelf


func _ready() -> void:
	button.pressed.connect(Events.shop_exited.emit)
	
	for shop_item in item_shelf.get_children():
		shop_item.queue_free()
	
	for shop_item in artifact_shelf.get_children():
		shop_item.queue_free()


func populate_shop() -> void:
	_generate_shop_items()


func _generate_shop_items() -> void:
	var shop_items_array: Array[Item] = []
	ItemConfig
