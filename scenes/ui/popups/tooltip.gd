class_name Tooltip
extends Control

const TOOLTIP_PANEL_SCENE = preload("res://scenes/ui/popups/tooltip_panel.tscn")
const OFFSET := 10


func _ready() -> void:
	Events.request_show_tooltip.connect(_on_request_show_tooltip)
	Events.hide_tooltip.connect(_on_hide_tooltip)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("expand"):
		_toggle_secondary_tooltip(true)
	elif event.is_action_released("expand"):
		_toggle_secondary_tooltip(false)


func _toggle_secondary_tooltip(show_tooltip: bool) -> void:
	var secondary_tooltips = get_tree().get_nodes_in_group("secondary_tooltip")

	for tooltip in secondary_tooltips:
		tooltip.visible = show_tooltip

	set_process_unhandled_key_input(true)


func _create_tooltip(header: String, description: String) -> Panel:
	var tooltip_instance := TOOLTIP_PANEL_SCENE.instantiate()
	add_child(tooltip_instance)
	tooltip_instance.get_node("%NameLabel").text = header
	tooltip_instance.get_node("%DescriptionLabel").text = description
	return tooltip_instance


func _on_request_show_tooltip(tooltip_owner: Node, main: Dictionary, secondary: Array) -> void:
	var main_tooltip = _create_tooltip(main.name, main.description)
	global_position = tooltip_owner.global_position

	if tooltip_owner.global_position.x <= (get_viewport_rect().size.x / 2):
		global_position.x = tooltip_owner.global_position.x + tooltip_owner.size.x
	else:
		global_position.x = tooltip_owner.global_position.x - main_tooltip.size.x

	if get_viewport_rect().size.y <= global_position.y + main_tooltip.size.y:
		global_position.y = (
			global_position.y
			- (global_position.y + main_tooltip.size.y - get_viewport_rect().size.y)
		)

	main_tooltip.visible = true

	if not secondary.is_empty():
		var keycode = Utils.get_keycode_from_input_id("expand")
		main_tooltip.get_node("%ExpandLabel").text = "[%s] to expand" % keycode
		main_tooltip.get_node("%ExpandLabel").visible = true

	var secondary_count := 1
	for secondary_tooltip in secondary:
		var tooltip = _create_tooltip(secondary_tooltip.name, secondary_tooltip.description)
		tooltip.add_to_group("secondary_tooltip")

		if tooltip_owner.global_position.y <= (get_viewport_rect().size.y / 2):
			tooltip.global_position.y += (secondary_count * tooltip.size.y) + OFFSET
		else:
			tooltip.global_position.y -= (secondary_count * tooltip.size.y) + OFFSET

		secondary_count += 1


func _on_hide_tooltip() -> void:
	for child in get_children():
		child.queue_free()
