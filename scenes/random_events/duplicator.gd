class_name Duplicator
extends Node2D

@export var party_manager: PartyManager : set = set_party_manager

@onready var source_button: Button = %SourceButton
@onready var sacrifice_button: Button = %SacrificeButton
@onready var duplicate_button: Button = %DuplicateButton
@onready var leave_button: Button = %LeaveButton
@onready var source_unit_icon_panel: UnitIconPanel = %SourceUnitIconPanel
@onready var sacrifice_unit_icon_panel: UnitIconPanel = %SacrificeUnitIconPanel
@onready var party_ui_panel: Panel = %PartyUIPanel
@onready var party_ui: PartyUI = %PartyUI
@onready var ui_layer: CanvasLayer = %UI

var selected_panel: UnitIconPanel


func _ready() -> void:
	duplicate_button.pressed.connect(_on_duplicate_button_pressed)
	leave_button.pressed.connect(Events.random_event_exited.emit)
	source_button.pressed.connect(_on_button_pressed.bind(source_unit_icon_panel))
	sacrifice_button.pressed.connect(_on_button_pressed.bind(sacrifice_unit_icon_panel))
	party_ui.unit_selected.connect(_on_unit_selected)

	source_unit_icon_panel.unit_stats = null
	sacrifice_unit_icon_panel.unit_stats = null


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		if party_ui_panel.visible:
			selected_panel.unit_stats = null
			party_ui_panel.visible = false
			duplicate_button.disabled = true


func set_party_manager(value: PartyManager) -> void:
	party_manager = value
	party_ui.party_manager = value


func _on_duplicate_button_pressed() -> void:
	party_manager.remove_unit(sacrifice_unit_icon_panel.unit_stats)
	var new_unit_creator_ui: UnitCreatorUI = UnitCreatorUI.create_new(source_unit_icon_panel.unit_stats.duplicate())
	ui_layer.add_child(new_unit_creator_ui)
	new_unit_creator_ui.unit_created.connect(_on_unit_created)
	


func _on_button_pressed(panel: UnitIconPanel) -> void:
	selected_panel = panel

	if source_unit_icon_panel.unit_stats or sacrifice_unit_icon_panel.unit_stats:
		party_ui.reset_buttons()
		party_ui.disable_button(source_unit_icon_panel.unit_stats)
		party_ui.disable_button(sacrifice_unit_icon_panel.unit_stats)

	party_ui_panel.show()


func _on_unit_created(new_unit: UnitStats) -> void:
	party_manager.add_unit(new_unit)
	Events.random_event_exited.emit()


func _on_unit_selected(unit: UnitStats) -> void:
	selected_panel.unit_stats = unit
	party_ui_panel.hide()

	if source_unit_icon_panel.unit_stats and sacrifice_unit_icon_panel.unit_stats:
		duplicate_button.disabled = false
