extends EnemyAI
class_name MultiTileEnemyAI

var next_tiles: Array[Vector2i]
var target_tiles: Array[Vector2i]

func select_target(get_id_path: Callable, arena: Arena) -> void:
	printt("in range: ", targets_in_range)
	printt("out range: ", targets_out_of_range)
	current_target = null
	next_tile = Vector2i.ZERO
#
	if targets_in_range.is_empty():
		_find_closest_target(get_id_path, arena)
#
	for target in targets_in_range:
		var target_unit: Unit = target["target"]
		var tiles: Array[Vector2i] = target["tiles"]
		var starting_tile: Vector2i = target["starting_tile"]

		for tile in tiles:
			var temp_path: Array[Vector2i] = get_id_path.call(starting_tile, tile)
			if temp_path.size() - 1 > owner.stats.movement: continue
			if not _valid_ending_tile(tile, arena):
				if _try_surrounding_tiles(tile, arena, starting_tile).is_empty():
					continue
			current_target = target_unit
			next_tile = tile
#
	if not current_target:
		_find_closest_target(get_id_path, arena)


func _find_closest_target(get_id_path: Callable, arena: Arena) -> void:
	current_target = null
	next_tile = Vector2i.ZERO
	in_range = false

	var shortest_distance := 99

	for target in targets_out_of_range:
		var target_unit: Unit = target["target"]
		var tiles: Array[Vector2i] = target["tiles"]
		var starting_tile: Vector2i = target["starting_tile"]

		for tile in tiles:
			var temp_path: Array[Vector2i] = get_id_path.call(starting_tile, tile)
			if temp_path.is_empty(): continue
			if not _valid_ending_tile(tile, arena):
				var surrounding_tiles := _try_surrounding_tiles(tile, arena, starting_tile)
				if surrounding_tiles.is_empty():
					continue
				else:
					for new_tile in surrounding_tiles:
						temp_path = get_id_path.call(starting_tile, new_tile)

			current_target = target_unit
			next_tile = temp_path[clampi(owner.stats.movement, 0, temp_path.size())]


func _valid_ending_tile(tile: Vector2i, arena: Arena) -> bool:
	var dimensions := owner.stats.dimensions
	var valid_tiles: Array[Vector2i] = []

	for i in dimensions.x:
		for j in dimensions.y:
			var temp_x = tile.x - i
			var temp_y = tile.y - j
			if not arena.is_tile_in_bounds(Vector2i(temp_x, temp_y)): continue
			if arena.arena_grid.is_tile_occupied(Vector2i(temp_x, temp_y)): continue
			valid_tiles.append(Vector2i(temp_x, temp_y))

	return valid_tiles.size() == dimensions.x * dimensions.y


func _try_surrounding_tiles(tile, arena, starting_tile: Vector2i) -> Array[Vector2i]:
	var delta: Vector2i = (tile - starting_tile).abs()
	var surrounding_tiles: Array[Vector2i] = []
	var valid_tiles: Array[Vector2i] = []

	if delta.y >= delta.x:
		surrounding_tiles.append(tile + Vector2i.RIGHT)
		surrounding_tiles.append(tile + Vector2i.LEFT)
	else:
		surrounding_tiles.append(tile + Vector2i.UP)
		surrounding_tiles.append(tile + Vector2i.DOWN)

	if surrounding_tiles.is_empty(): return []

	for surrounding_tile in surrounding_tiles:
		if not arena.is_tile_in_bounds(surrounding_tile): continue
		if arena.arena_grid.is_tile_occupied(surrounding_tile): continue
		if not _valid_ending_tile(surrounding_tile, arena): continue

		valid_tiles.append(surrounding_tile)
	return valid_tiles
