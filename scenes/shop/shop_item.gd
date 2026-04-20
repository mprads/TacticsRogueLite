class_name ShopItem
extends Control

const SHOP_ITEM_SCENE = preload("uid://bx3amx8rinwo")

@export var item: Item : set = set_item
@export var outline_thickness: float = 1.0

@onready var item_icon_button: TextureButton = %ItemIconButton
@onready var gold_cost: Label = %GoldCost
@onready var item_container: VBoxContainer = %ItemContainer
@onready var discont_tag: Control = %DiscontTag
@onready var discount_gold_cost: Label = %DiscountGoldCost
@onready var upcharge_tag: Control = %UpchargeTag
@onready var upcharge_gold_cost: Label = %UpchargeGoldCost


func _ready() -> void:
	item_icon_button.mouse_entered.connect(_on_mouse_entered)
	item_icon_button.mouse_exited.connect(_on_mouse_exited)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	item_icon_button.pressed.connect(_on_purchase_item)


func update_gold_cost(change: float) -> void:
	if not item or not change:
		return

	var base_item := ItemConfig.get_item_resource(item.key)
	var new_cost := floori(base_item.gold_cost * change)
	var delta := new_cost - base_item.gold_cost
	item.update_gold_cost(floori(item.gold_cost + delta))
	if item.gold_cost > base_item.gold_cost:
		upcharge_tag.visible = true
	elif item.gold_cost < base_item.gold_cost:
		discont_tag.visible = true
	else:
		upcharge_tag.visible = false
		discont_tag.visible = false


func update(player_gold: int) -> void:
	if not is_node_ready():
		await ready

	if not item or not item_container: return

	var item_gold_cost = str(item.gold_cost)
	gold_cost.text = item_gold_cost
	discount_gold_cost.text = item_gold_cost
	upcharge_gold_cost.text = item_gold_cost

	if item.gold_cost > player_gold:
		item_icon_button.disabled = true
		gold_cost.modulate = Color.RED
		discount_gold_cost.modulate = Color.RED
		upcharge_gold_cost.modulate = Color.RED
	else:
		item_icon_button.disabled = false
		gold_cost.modulate = Color.WHITE
		discount_gold_cost.modulate = Color.WHITE
		upcharge_gold_cost.modulate = Color.WHITE


func set_item(value: Item) -> void:
	if not is_node_ready():
		await ready

	item = value.duplicate()

	gold_cost.text = str(item.gold_cost)
	item_icon_button.texture_normal = item.icon
	item_icon_button.texture_disabled = item.icon


func _on_purchase_item() -> void:
	item_container.queue_free()
	discont_tag.queue_free()
	upcharge_tag.queue_free()
	Events.request_purchase_item.emit(item)


func _on_mouse_entered() -> void:
	if not item or not item_container: return

	item_icon_button.material.set_shader_parameter('outline_thickness', outline_thickness)


func _on_mouse_exited() -> void:
	if not item or not item_container: return

	item_icon_button.material.set_shader_parameter('outline_thickness', 0.0)


static func create_new(new_item: Item) -> ShopItem:
	var new_shop_item := SHOP_ITEM_SCENE.instantiate()
	new_shop_item.item = new_item
	return new_shop_item
