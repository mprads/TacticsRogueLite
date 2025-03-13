extends Node2D
class_name Battle

const UNIT = preload("res://scenes/unit/unit.tscn")
const TEST_UNIT = preload("res://resources/units/test_unit.tres")
const SQUARE_BOTTLE = preload("res://resources/bottles/square_bottle.tres")
const YELLOW_POTION = preload("res://resources/potions/yellow_potion.tres")

@onready var button: Button = $UI/VBoxContainer/Button


func _ready() -> void:
	button.pressed.connect(Events.battle_exited.emit)
	
	var new_unit = UNIT.instantiate()
	add_child(new_unit)
	var unit_data = TEST_UNIT.duplicate()
	unit_data.bottle = SQUARE_BOTTLE.duplicate()
	unit_data.potion = YELLOW_POTION.duplicate()
	print(Vector2(unit_data.bottle.sprite_coordinates))
	new_unit.stats = unit_data
