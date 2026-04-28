class_name SettingsUI
extends Control

# Should just be a preload but engine issue #104769 where jumping between scenes is
# nulling out packed scene references
@onready var MAIN_MENU_SCENE = load("uid://r7l5dv2hbg2g")

@onready var close_button: Button = %CloseButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_close_button_pressed() -> void:
	visible = false


func _on_main_menu_button_pressed() -> void:
	SceneChanger.change_scene(MAIN_MENU_SCENE, null)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
