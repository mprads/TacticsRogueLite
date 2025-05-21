extends EnemyAI
class_name WraithAI

var next_tiles: Array[Vector2i]
var target_tiles: Array[Vector2i]


func select_target(get_id_path: Callable) -> void:
	current_target = null
	next_tile = Vector2i.ZERO

	if targets_in_range.is_empty():
		_find_closest_target(get_id_path)


func _find_closest_target(get_id_path: Callable) -> void:
	current_target = null
	next_tile = Vector2i.ZERO
	in_range = false

	var shortest_distance := 99

	for target in targets_out_of_range:
		var target_unit: Unit = target["target"]
		var tiles: Array[Vector2i] = target["tiles"]
		var starting_tile: Vector2i = target["starting_tile"]

		var distance_by_tiles: Dictionary[Vector2i, int] = {}

		for tile in tiles:
			var temp_path: Array[Vector2i] = get_id_path.call(starting_tile, tile)
			if temp_path.is_empty(): continue
			var distance := temp_path.size()

			distance_by_tiles[tile] = distance

			if distance < shortest_distance:
				current_target = target_unit
				next_tile = temp_path[clampi(owner.stats.movement, 0, temp_path.size())]
