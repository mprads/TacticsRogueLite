extends Control
class_name RunComplete

const MAIN_MENU_SCENE := preload("res://scenes/main_menu/main_menu.tscn")

@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _on_main_menu_button_pressed() -> void:
	SceneChanger.change_scene(MAIN_MENU_SCENE, null)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
