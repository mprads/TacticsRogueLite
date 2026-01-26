class_name HotKeyRebindButton
extends Control

@export var action_name: String = ""
@export var input_map_id: String = ""

@onready var label: Label = %Label
@onready var button: Button = %Button


func _ready() -> void:
	button.toggled.connect(_on_button_toggled)
	set_process_unhandled_key_input(false)
	label.text = action_name
	_set_text_for_key()


func _unhandled_key_input(event: InputEvent) -> void:
	_rebind_action_key(event)
	button.button_pressed = false


func _rebind_action_key(event) -> void:
	InputMap.action_erase_events(input_map_id)
	InputMap.action_add_event(input_map_id, event)

	set_process_unhandled_key_input(false)
	_set_text_for_key()


func _set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(input_map_id)
	print(action_events.size())
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)

	button.text = "%s" % action_keycode


func _on_button_toggled(button_pressed) -> void:
	if button_pressed:
		button.text = "Press any key..."
		set_process_unhandled_key_input(true)

		for key in get_tree().get_nodes_in_group("hot_key_button"):
			if key.input_map_id != self.input_map_id:
				key.button.toggle_mode = false
				key.set_process_unhandled_key_input(false)
	else:
		for key in get_tree().get_nodes_in_group("hot_key_button"):
			if key.input_map_id != self.input_map_id:
				key.button.toggle_mode = true
				key.set_process_unhandled_key_input(false)

		_set_text_for_key()
