extends Control
class_name ShopItem

@export var item: Item : set = set_item

@onready var item_icon_button: TextureButton = %ItemIconButton
@onready var gold_cost: Label = %GoldCost
@onready var item_container: VBoxContainer = %ItemContainer


func _ready() -> void:
	item_icon_button.pressed.connect(_on_purchase_item)


func update(player_gold: int) -> void:
	if not item or not item_container: return

	gold_cost.text = str(item.gold_cost)

	if item.gold_cost > player_gold:
		item_icon_button.disabled = true
		gold_cost.modulate = Color.RED
	else:
		item_icon_button.disabled = false
		gold_cost.modulate = Color.WHITE


func set_item(value: Item) -> void:
	if not is_node_ready():
		await ready

	item = value

	gold_cost.text = str(item.gold_cost)
	item_icon_button.texture_normal = item.icon
	item_icon_button.texture_disabled = item.icon


func _on_purchase_item() -> void:
	item_container.queue_free()
	Events.request_purchase_item.emit(item)
