class_name RoundBottleButton
extends TextureButton

signal request_purchase(bottle: Bottle)

@export var bottle: Bottle:
	set = set_bottle
@export var outline_thickness: float = 1.0

@onready var gold_cost: Label = %GoldCost
@onready var discont_tag: Control = %DiscontTag
@onready var upcharge_tag: Control = %UpchargeTag
@onready var discount_gold_cost: Label = %DiscountGoldCost
@onready var upcharge_gold_cost: Label = %UpchargeGoldCost


func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func update_gold_cost(change: float) -> void:
	if not bottle or not change:
		return

	var new_cost := floori(bottle.gold_cost * change)
	if new_cost > bottle.gold_cost:
		upcharge_tag.visible = true
	elif new_cost < bottle.gold_cost:
		discont_tag.visible = true
	else:
		upcharge_tag.visible = false
		discont_tag.visible = false

	bottle.update_gold_cost(new_cost)


func update(player_gold: int) -> void:
	if not is_node_ready():
		await ready

	var bottle_gold_cost = str(bottle.gold_cost)
	gold_cost.text = bottle_gold_cost
	discount_gold_cost.text = bottle_gold_cost
	upcharge_gold_cost.text = bottle_gold_cost
	
	if bottle.gold_cost > player_gold:
		disabled = true
		gold_cost.modulate = Color.RED
		discount_gold_cost.modulate = Color.RED
		upcharge_gold_cost.modulate = Color.RED
	else:
		disabled = false
		gold_cost.modulate = Color.WHITE
		discount_gold_cost.modulate = Color.WHITE
		upcharge_gold_cost.modulate = Color.WHITE


func set_bottle(value: Bottle) -> void:
	bottle = value

	if not is_node_ready():
		await ready

	if not bottle:
		return

	var bottle_gold_cost = str(bottle.gold_cost)
	gold_cost.text = bottle_gold_cost
	discount_gold_cost.text = bottle_gold_cost
	upcharge_gold_cost.text = bottle_gold_cost


func _on_pressed() -> void:
	request_purchase.emit(bottle)


func _on_mouse_entered() -> void:
	material.set_shader_parameter("outline_thickness", outline_thickness)
	var description := (
		"HP: %s\nOZ: %s\nMovement: %s" % [bottle.base_health, bottle.max_oz, bottle.base_movement]
	)
	var main_tooltip := {"name": bottle.name, "description": description}

	Events.request_show_tooltip.emit(self, main_tooltip, [])


func _on_mouse_exited() -> void:
	material.set_shader_parameter("outline_thickness", 0.0)
	Events.hide_tooltip.emit()
