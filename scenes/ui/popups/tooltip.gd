class_name Tooltip
extends Control

const OFFSET := 10
const TOP_NAV_HEIGHT := 28
const TOP_NAV_OFFSET := 40

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


func _on_request_show_tooltip(tooltip_owner: Node, main: Dictionary, secondary: Array) -> void:
	var main_tooltip = TooltipPanel.create_new(main.name, main.description)
	add_child(main_tooltip)
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

	if global_position.y <= TOP_NAV_HEIGHT:
		global_position.y = TOP_NAV_OFFSET

	main_tooltip.visible = true

	if not secondary.is_empty():
		var keycode = Utils.get_keycode_from_input_id("expand")
		main_tooltip.get_node("%ExpandLabel").text = "[%s] to expand" % keycode
		main_tooltip.get_node("%ExpandLabel").visible = true

	var secondary_count := 1
	for secondary_tooltip in secondary:
		var tooltip = TooltipPanel.create_new(secondary_tooltip.name, secondary_tooltip.description)
		add_child(tooltip)
		tooltip.add_to_group("secondary_tooltip")

		if tooltip_owner.global_position.y <= (get_viewport_rect().size.y / 2):
			tooltip.global_position.y += (secondary_count * tooltip.size.y) + OFFSET
		else:
			tooltip.global_position.y -= (secondary_count * tooltip.size.y) + OFFSET

		secondary_count += 1


func _on_hide_tooltip() -> void:
	for child in get_children():
		child.queue_free()
