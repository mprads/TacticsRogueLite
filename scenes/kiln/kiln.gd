class_name Kiln
extends Node2D

@export var party_manager: PartyManager:
	set = set_party_manager
@export var sfx_key := SFXConfig.KEYS.KILN

@onready var party_ui: PartyUI = %PartyUI
@onready var kiln_unit_icon_panel: UnitIconPanel = %UnitIconPanel
@onready var heal_button: Button = %HealButton
@onready var leave_button: Button = %LeaveButton


func _ready() -> void:
	heal_button.pressed.connect(_on_heal_button_pressed)
	leave_button.pressed.connect(_on_leave_button_pressed)
	party_ui.unit_selected.connect(_on_party_unit_selected)

	SFXPlayer.play(SFXConfig.get_audio_stream(sfx_key))

	kiln_unit_icon_panel.unit_stats = null


func set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value
	# TODO Ew prop drilling
	party_ui.party_manager = party_manager


func _on_heal_button_pressed() -> void:
	heal_button.disabled = true

	if kiln_unit_icon_panel.unit_stats:
		kiln_unit_icon_panel.unit_stats.heal(
			ceili(kiln_unit_icon_panel.unit_stats.max_health * 0.3)
		)

	Events.kiln_exited.emit()


func _on_leave_button_pressed() -> void:
	SFXPlayer.stop()
	Events.kiln_exited.emit()


func _on_party_unit_selected(unit_stats: UnitStats) -> void:
	kiln_unit_icon_panel.unit_stats = unit_stats
