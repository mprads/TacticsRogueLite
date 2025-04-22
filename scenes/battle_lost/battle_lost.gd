extends Control
class_name BattleLost

@export var party_manager: PartyManager : set = set_party_manager

@onready var party_ui: PartyUI = %PartyUI
@onready var retry_button: Button = %RetryButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	retry_button.pressed.connect(_on_retry_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value
	
	party_ui.party_manager = party_manager
	
	if party_ui.party.size() == 0:
		retry_button.disabled = true


func _on_retry_button_pressed() -> void:
	Events.retry_battle.emit()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
