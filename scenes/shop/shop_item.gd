extends Control
class_name ShopItem

@export var item: Item : set = set_item

@onready var item_icon: TextureRect = %ItemIcon
@onready var gold_cost: Label = %GoldCost


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			print(item.gold_cost)
			accept_event()


func set_item(value: Item) -> void:
	if not is_node_ready():
		await ready
	
	item = value
	
	gold_cost.text = str(item.gold_cost)
	item_icon.texture = item.icon
