extends Control
class_name BattleReward

@onready var continue_button: Button = %ContinueButton


func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)


func _on_continue_button_pressed() -> void:
	Events.battle_reward_exited.emit()
