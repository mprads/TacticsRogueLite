class_name ShopBottle
extends Control

signal request_purchase(bottle: Bottle, clean_up_callback: Callable)

const SHOP_BOTTLE_SCENE = preload("uid://c05jbl2pod8hb")

@export var bottle: Bottle:
	set = set_bottle
@export var outline_thickness: float = 1.0

@onready var bottle_icon_button: TextureButton = %BottleIconButton
@onready var bottle_container: VBoxContainer = %BottleContainer
@onready var gold_cost: Label = %GoldCost


func _ready() -> void:
	bottle_icon_button.pressed.connect(_on_button_pressed)
	bottle_icon_button.mouse_entered.connect(_on_mouse_entered)
	bottle_icon_button.mouse_exited.connect(_on_mouse_exited)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func update(player_gold: int) -> void:
	if not bottle or not bottle_container:
		return

	gold_cost.text = str(bottle.gold_cost)

	if bottle.gold_cost > player_gold:
		bottle_icon_button.disabled = true
		gold_cost.modulate = Color.RED
	else:
		bottle_icon_button.disabled = false
		gold_cost.modulate = Color.WHITE


func purchased_cleanup() -> void:
	bottle_container.queue_free()


func set_bottle(value: Bottle) -> void:
	if not is_node_ready():
		await ready

	bottle = value

	gold_cost.text = str(bottle.gold_cost)
	bottle_icon_button.texture_normal = bottle.bottle_sprite
	bottle_icon_button.texture_disabled = bottle.bottle_sprite


func _on_mouse_entered() -> void:
	if not bottle or not bottle_container:
		return

	bottle_icon_button.material.set_shader_parameter("outline_thickness", outline_thickness)
	var description := (
		"HP: %s\nOZ: %s\nMovement: %s" % [bottle.base_health, bottle.max_oz, bottle.base_movement]
	)
	var main_tooltip := {"name": bottle.name, "description": description}

	Events.request_show_tooltip.emit(self, main_tooltip, [])


func _on_mouse_exited() -> void:
	if not bottle or not bottle_container:
		return

	bottle_icon_button.material.set_shader_parameter("outline_thickness", 0.0)
	Events.hide_tooltip.emit()


func _on_button_pressed() -> void:
	request_purchase.emit(bottle, purchased_cleanup)


static func create_new(new_bottle: Bottle) -> ShopBottle:
	var new_shop_bottle := SHOP_BOTTLE_SCENE.instantiate()
	new_shop_bottle.bottle = new_bottle
	return new_shop_bottle
