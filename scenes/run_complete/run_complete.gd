class_name RunComplete
extends Control

# Should just be a preload but engine issue #104769 where jumping between scenes is
# nulling out packed scene references
@onready var MAIN_MENU_SCENE = load("res://scenes/main_menu/main_menu.tscn")
@export var run_stats: RunStats

@onready var fireworks: Node2D = %Fireworks
@onready var title: Label = %Title
@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_button: Button = %QuitButton

var is_victory := false:
	set = set_is_victory


func _ready() -> void:
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func set_is_victory(value: bool) -> void:
	is_victory = value

	if is_victory:
		pass
	else:
		title.text = "Defeat"
		fireworks.visible = false


func _on_main_menu_button_pressed() -> void:
	SceneChanger.change_scene(MAIN_MENU_SCENE, run_stats)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
