extends Control
class_name ShopBottle

@export var bottle: Bottle : set = set_bottle

@onready var bottle_icon_button: TextureButton = %BottleIconButton
@onready var bottle_container: VBoxContainer = %BottleContainer
@onready var gold_cost: Label = %GoldCost


func update(player_gold: int) -> void:
	if not bottle or not bottle_container: return

	gold_cost.text = str(bottle.gold_cost)

	if bottle.gold_cost > player_gold:
		bottle_icon_button.disabled = true
		gold_cost.modulate = Color.RED
	else:
		bottle_icon_button.disabled = false
		gold_cost.modulate = Color.WHITE


func set_bottle(value: Bottle) -> void:
	bottle = value

	gold_cost.text = str(bottle.gold_cost)
	bottle_icon_button.texture_normal = bottle.bottle_sprite
	bottle_icon_button.texture_disabled = bottle.bottle_sprite
