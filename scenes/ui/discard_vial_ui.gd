class_name DiscardVialUI
extends Control

signal vial_selected

const DISCARD_VIAL_UI_SCENE = preload("uid://bdw8glp5ymklh")


@export var vial_manager: VialManager:
	set = set_vial_manager

@onready var vial_container: VBoxContainer = %VialContainer
@onready var cancel_label: Label = %CancelLabel

var cancellable := false


func _ready() -> void:
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


func set_vial_manager(value: VialManager) -> void:
	if not is_node_ready():
		await ready

		for child in vial_container.get_children():
			child.queue_free()

	vial_manager = value
	for vial in vial_manager.get_vials():
		var vial_panel_instance := VialPanel.create_new(vial.potion)
		vial_container.add_child(vial_panel_instance)
		vial_panel_instance.pressed.connect(_on_vial_panel_pressed.bind(vial))


func _on_vial_panel_pressed(vial: Vial) -> void:
	vial_selected.emit(vial)
	queue_free()


static func create_new(new_vial_manager: VialManager, enable_cancel: bool = false) -> DiscardVialUI:
	var new_discard_vial_ui := DISCARD_VIAL_UI_SCENE.instantiate()
	new_discard_vial_ui.vial_manager = new_vial_manager
	new_discard_vial_ui.cancellable = enable_cancel
	return new_discard_vial_ui
