extends Control
class_name RunComplete

const PARTY_SELECT_SCENE = preload("res://scenes/party_select/party_select.tscn")

@export var run_stats: RunStats

@onready var fireworks: Node2D = %Fireworks
@onready var title: Label = %Title
@onready var new_run_button: Button = %NewRunButton
@onready var quit_button: Button = %QuitButton

var is_victory := false : set = set_is_victory

func _ready() -> void:
	new_run_button.pressed.connect(_on_new_run_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func set_is_victory(value: bool) -> void:
	is_victory = value

	if is_victory:
		pass
	else:
		title.text = "Defeat"
		fireworks.visible = false


func _on_new_run_button_pressed() -> void:
	SceneChanger.change_scene(PARTY_SELECT_SCENE, run_stats)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
