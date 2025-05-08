extends HBoxContainer
class_name GoldUI

@export var inventory_manager: InventoryManager : set = set_inventory_manager

@onready var label: Label = $Label

var tween: Tween
var gold: int = 0
var fake_count: int = 0 : set = set_fake_count

func _ready() -> void:
	label.text = "0"


func set_inventory_manager(value: InventoryManager) -> void:
	inventory_manager = value

	if not inventory_manager.gold_changed.is_connected(_update_gold):
		inventory_manager.gold_changed.connect(_update_gold)

	_update_gold()


func set_fake_count(value: int) -> void:
	fake_count = value
	label.text = str(fake_count)


func _update_gold() -> void:
	gold = inventory_manager.get_gold()

	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "fake_count", gold, .5)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN_OUT)
