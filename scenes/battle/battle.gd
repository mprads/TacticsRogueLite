extends Node2D
class_name Battle

const UNIT = preload("res://scenes/unit/unit.tscn")

@onready var button: Button = $UI/VBoxContainer/Button


func _ready() -> void:
	button.pressed.connect(Events.battle_won.emit)
