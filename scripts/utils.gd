class_name Utils
extends Object


static func get_distance_between_tiles(starting_tile: Vector2i, ending_tile: Vector2i) -> int:
	var delta: Vector2i = (ending_tile - starting_tile).abs()
	var distance := int(delta.x + delta.y)
	return distance


static func get_keycode_from_input_id(input_map_id: String) -> String:
	var action_events = InputMap.action_get_events(input_map_id)
	var action_event = action_events[0]
	return OS.get_keycode_string(action_event.physical_keycode)


static func format_seconds(time: int) -> String:
	return "%s:%s" % [str(time / 60), str(time % 60)]
