extends EnemyAI
class_name MultiTileEnemyAI

var aoe_targets: Array[Node]
var next_tiles: Array[Vector2i]
var target_tiles: Array[Vector2i]

func select_target(get_id_path: Callable, arena: Arena) -> void:
	printt("in range: ", targets_in_range)
	printt("out range: ", targets_out_of_range)
	current_target = null

	if targets_in_range.is_empty():
		_find_closest_target(get_id_path, arena)
		return

	for target in targets_in_range:
		var target_unit: Unit = target["target"]
		var tiles: Array[Vector2i] = target["tiles"]
		var starting_tile: Vector2i = target["starting_tile"]

		for tile in tiles:
			if tile == starting_tile:
				current_target = target_unit
				next_tile = starting_tile
				in_range = true
				continue

			var temp_path: Array[Vector2i] = get_id_path.call(starting_tile, tile)
			if temp_path.size() - 1 > owner.stats.movement: continue
			if not _valid_ending_tile(tile, arena):
				if _try_surrounding_tiles(tile, arena, starting_tile).is_empty():
					continue
			current_target = target_unit
			next_tile = tile
			in_range = true
			selected_ability = owner.stats.melee_ability

	if not current_target:
		_find_closest_target(get_id_path, arena)


func populate_multi_tile_targets(arena: Arena) -> void:
	target_tiles = []
	next_tiles = []
	aoe_targets = []

	if not current_target: return
	var dimensions = owner.stats.dimensions
	var target_tile := arena.get_tile_from_global(current_target.global_position)
	var delta: Vector2i = (target_tile - next_tile).abs()
	var ability := owner.stats.melee_ability

	for i in dimensions.x:
		for j in dimensions.y:
			var temp_x = next_tile.x - i
			var temp_y = next_tile.y - j
			next_tiles.append(Vector2i(temp_x, temp_y))

	if not in_range and owner.stats.ranged_ability:
		ability = owner.stats.ranged_ability

	if delta.x <= delta.y:
		if delta.x == 0:
			for tile in ability.shape:
				target_tiles.append(target_tile + tile)
		elif delta.x == 1:
			for tile in ability.shape:
				target_tiles.append(target_tile + (tile * -1))
	else:
		if delta.y == 0:
			for tile in ability.shape:
				var inverted_tile := Vector2i(tile.y, tile.x)
				target_tiles.append(target_tile + inverted_tile)
		elif delta.y == 1:
			for tile in ability.shape:
				var inverted_tile := Vector2i(tile.y, tile.x)
				target_tiles.append(target_tile + (inverted_tile * -1))

	if not target_tiles.is_empty():
		for tile in target_tiles:
			var target := arena.arena_grid.get_occupant(tile)
			if target is Unit:
				aoe_targets.append(target)


func _find_closest_target(get_id_path: Callable, arena: Arena) -> void:
	current_target = null
	in_range = false

	for target in targets_out_of_range:
		var target_unit: Unit = target["target"]
		var tiles: Array[Vector2i] = target["tiles"]
		var starting_tile: Vector2i = target["starting_tile"]

		for tile in tiles:
			if tile == starting_tile:
				current_target = target_unit
				next_tile = starting_tile
				selected_ability = owner.stats.ranged_ability
				continue

			var temp_path: Array[Vector2i] = get_id_path.call(starting_tile, tile)
			if temp_path.is_empty(): continue
			if not _valid_ending_tile(tile, arena):
				var surrounding_tiles := _try_surrounding_tiles(tile, arena, starting_tile)
				if surrounding_tiles.is_empty():
					current_target = target_unit
					next_tile = starting_tile
					selected_ability = owner.stats.ranged_ability
					continue
				else:
					for new_tile in surrounding_tiles:
						if new_tile == starting_tile:
							current_target = target_unit
							next_tile = starting_tile
							selected_ability = owner.stats.ranged_ability
							continue
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
