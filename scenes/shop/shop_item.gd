extends Control
class_name ShopItem

@export var item:Item : set = set_item

@onready var item_icon: TextureRect = %ItemIcon
@onready var gold_cost: Label = %GoldCost


func set_item(value: Item) -> void:
	if not is_node_ready():
		await ready
	
	item = value
	
	gold_cost.text = str(item.gold_cost)
	item_icon.texture = item.icon
