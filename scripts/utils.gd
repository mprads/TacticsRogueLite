extends Object
class_name Utils


static func get_distance_between_tiles(starting_tile: Vector2i, ending_tile: Vector2i) -> int:
	var delta: Vector2i = (ending_tile - starting_tile).abs()
	var distance := int(delta.x + delta.y)
	return distance
