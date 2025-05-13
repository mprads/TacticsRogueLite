extends TextureButton
class_name RoundBottleButton

signal request_purchase(bottle: Bottle)

@export var bottle: Bottle : set = set_bottle

@onready var gold_cost: Label = %GoldCost


func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func update(player_gold: int) -> void:
	if bottle.gold_cost > player_gold:
		disabled = true
		gold_cost.modulate = Color.RED
	else:
		disabled = false
		gold_cost.modulate = Color.WHITE


func set_bottle(value: Bottle) -> void:
	bottle = value

	if not is_node_ready():
		await ready

	if not bottle: return
	gold_cost.text = str(bottle.gold_cost)


func _on_pressed() -> void:
	request_purchase.emit(bottle)


func _on_mouse_entered() -> void:
	var description := "HP: %s\nOZ: %s\nMovement: %s" % [bottle.base_health, bottle.max_oz, bottle.base_movement]
	var main_tooltip := { "name": bottle.name, "description": description }

	Events.request_show_tooltip.emit(self, main_tooltip, [])


func _on_mouse_exited() -> void:
	Events.hide_tooltip.emit()
