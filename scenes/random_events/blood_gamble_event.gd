class_name BloodGambleEvent
extends Node2D

@onready var pay_life_button: Button = %PayLifeButton
@onready var leave_button: Button = %LeaveButton


func _ready() -> void:
	leave_button.pressed.connect(Events.random_event_exited.emit)
