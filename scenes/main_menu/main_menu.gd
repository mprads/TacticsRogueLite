class_name MainMenu
extends Control

const RUN_SCENE = preload("uid://r76gjny5escp")
const PARTY_SELECT_SCENE = preload("uid://dyaf53aaous6t")
const TESTING_RUN_STATS = preload("uid://cog76ftpquwhv")

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

	MusicPlayer.play(SFXConfig.get_audio_stream(SFXConfig.KEYS.TITLE_MUSIC), true)


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
	SceneChanger.change_scene(PARTY_SELECT_SCENE, run_stats)


func _on_setting_button_pressed() -> void:
	settings_ui.visible = true


func _on_exit_button_pressed() -> void:
	get_tree().quit()
