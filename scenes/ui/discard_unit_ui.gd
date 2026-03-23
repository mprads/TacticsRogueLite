class_name DiscardUnitUI
extends Control

signal unit_removed

const DISCARD_UNIT_UI_SCENE = preload("uid://b8t2vqmevv3nx")


@export var party_manager: PartyManager:
	set = set_party_manager

@onready var party_ui: PartyUI = %PartyUI
@onready var cancel_label: Label = %CancelLabel

var cancellable := false


func _ready() -> void:
	party_ui.unit_selected.connect(_on_unit_selected)

	if cancellable:
		var keycode = Utils.get_keycode_from_input_id("cancel")
		cancel_label.text = "Press [%s] to cancel" % keycode
	else: 
		cancel_label.text = ""


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		if cancellable:
			#visible = false
			queue_free()


func set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value
	party_ui.party_manager = party_manager


func _on_unit_selected(unit_stats: UnitStats) -> void:
	party_manager.remove_unit(unit_stats)
	unit_removed.emit()
	queue_free()


static func create_new(new_party_manager: PartyManager, enable_cancel: bool = false) -> DiscardUnitUI:
	var new_discard_unit_ui := DISCARD_UNIT_UI_SCENE.instantiate()
	new_discard_unit_ui.party_manager = new_party_manager
	new_discard_unit_ui.cancellable = enable_cancel
	return new_discard_unit_ui
