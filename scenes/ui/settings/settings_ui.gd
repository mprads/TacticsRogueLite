class_name SettingsUI
extends Control

@onready var exit_button: Button = $ExitButton


func _ready() -> void:
	exit_button.pressed.connect(_on_exit_button_pressed)


func _on_exit_button_pressed() -> void:
	visible = false
