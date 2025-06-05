class_name ShopItem
extends Control

@export var item: Item : set = set_item
@export var outline_thickness: float = 1.0

@onready var item_icon_button: TextureButton = %ItemIconButton
@onready var gold_cost: Label = %GoldCost
@onready var item_container: VBoxContainer = %ItemContainer


func _ready() -> void:
	item_icon_button.mouse_entered.connect(_on_mouse_entered)
	item_icon_button.mouse_exited.connect(_on_mouse_exited)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
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


func _on_mouse_entered() -> void:
	if not item or not item_container: return

	item_icon_button.material.set_shader_parameter('outline_thickness', outline_thickness)


func _on_mouse_exited() -> void:
	if not item or not item_container: return

	item_icon_button.material.set_shader_parameter('outline_thickness', 0.0)
