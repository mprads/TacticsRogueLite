class_name MapLine
extends Line2D

const MAP_LINE_SCENE = preload("uid://cqxnj7v55fakb")


static func create_new(starting_room: Room, next_room: Room) -> MapLine:
	var new_map_line := MAP_LINE_SCENE.instantiate()
	new_map_line.add_point(starting_room.position)
	new_map_line.add_point(next_room.position)
	return new_map_line
