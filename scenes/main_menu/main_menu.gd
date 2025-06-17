class_name MainMenu
extends Control

const RUN_SCENE = preload("res://scenes/run/run.tscn")
const TESTING_RUN_STATS = preload("res://resources/testing_run_stats.tres")
const PARTY_SELECT = preload("res://scenes/party_select/party_select.tscn")

@onready var contiune_button: Button = %ContiuneButton
@onready var new_run_button: Button = %NewRunButton
@onready var setting_button: Button = %SettingButton
@onready var exit_button: Button = %ExitButton
@onready var settings_ui: Control = %SettingsUI
@onready var rng_seed_line_edit: LineEdit = $RNGSeedTextEdit


func _ready() -> void:
	contiune_button.pressed.connect(_on_continue_button_pressed)
	new_run_button.pressed.connect(_on_new_run_button_pressed)
	setting_button.pressed.connect(_on_setting_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)


func _on_continue_button_pressed() -> void:
	SceneChanger.change_scene(RUN_SCENE, TESTING_RUN_STATS)


func _on_new_run_button_pressed() -> void:
	var run_stats = RunStats.new()
	run_stats.rng_seed = RNG.instance.seed

	if rng_seed_line_edit.text:
		if int(rng_seed_line_edit.text) == 0:
			RNG.set_seed(hash(rng_seed_line_edit.text))
			run_stats.rng_seed = hash(rng_seed_line_edit.text)
		else:
			RNG.set_seed(int(rng_seed_line_edit.text))
			run_stats.rng_seed = int(rng_seed_line_edit.text)
	SceneChanger.change_scene(PARTY_SELECT, run_stats)


func _on_setting_button_pressed() -> void:
	settings_ui.visible = true


func _on_exit_button_pressed() -> void:
	get_tree().quit()
