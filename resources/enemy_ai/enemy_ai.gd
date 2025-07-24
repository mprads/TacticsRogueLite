class_name EnemyAI
extends Resource

var owner: Enemy
var targets_in_range: Array[Dictionary]
var targets_out_of_range: Array[Dictionary]

var current_target: Area2D
var aoe_targets: Array[Area2D]
var target_tiles: Array[Vector2i]
var next_tile: Vector2i
var next_tiles: Array[Vector2i]
var selected_ability: Ability

var in_range := false


func select_target(get_id_path: Callable, arena: Arena) -> void:
	current_target = null
	in_range = false
	selected_ability = owner.stats.ranged_ability

	if targets_in_range.is_empty():
		_find_closest_target(get_id_path, arena)
		return

	var highest_weight := 0.0

	for target in targets_in_range:
		var target_unit: Unit = target["target"]
		var tiles: Array[Vector2i] = target["tiles"]
		var starting_tile: Vector2i = target["starting_tile"]
		# Find new hp, then find the remaining hp. Minus remaining from 1 to prioritize kills
		# and values closer to 0

		# TODO added modifier logic to calculation. Maybe add shield to calc but can make for interesting
		# gameplay baiting attacks on a low life unit
		var new_health: int = clampi(
			target_unit.stats.health - owner.stats.melee_ability.base_damage,
			0,
			target_unit.stats.health
		)
		var remaining_percent := float(new_health) / target_unit.stats.max_health

		var damage_weight = 1 - remaining_percent

		var weight_by_tiles: Dictionary[Vector2i, float] = {}
		var highest_tile_weight := 0.0

		# For each tile in range of target unit check the distance to starting tile
		# weight less movement higher
		for tile in tiles:
			# Placeholder so it can be replaced by try_surrounding_tiles if it is not a valid
			# ending tile for enemies larger than 1 tile
			var potential_tile := tile
			var current_path: Array[Vector2i] = get_id_path.call(starting_tile, potential_tile)
			if current_path.size() - 1 > owner.stats.movement:
				continue
			if not _valid_ending_tile(potential_tile, arena):
				var surrounding_tiles := _try_surrounding_tiles(
					potential_tile, arena, starting_tile
				)
				if surrounding_tiles.is_empty():
					continue

				var closest_surrounding_tile := tile
				var viable_path_length := 99
				var potential_path := current_path
				for surrounding_tile in surrounding_tiles:
					var surrounding_path: Array[Vector2i] = get_id_path.call(
						starting_tile, surrounding_tile
					)
					if surrounding_path.size() - 1 > owner.stats.movement:
						continue
					if surrounding_path.size() < viable_path_length:
						closest_surrounding_tile = surrounding_tile
						viable_path_length = surrounding_path.size()
						potential_path = surrounding_path
				if closest_surrounding_tile != tile:
					potential_tile = closest_surrounding_tile
					current_path = potential_path
				else:
					continue

			var distance := current_path.size()
			var max_weight := (float(owner.stats.movement) / 100) + 0.1
			var movement_weight := max_weight - (float(distance) / 100)

			weight_by_tiles[potential_tile] = movement_weight

			if movement_weight > highest_tile_weight:
				highest_tile_weight = movement_weight

		var weight_sum = damage_weight + highest_tile_weight

		if weight_by_tiles.is_empty() or highest_tile_weight == 0.0:
			continue

		# Should target the unit it can put the closest to low % hp, movement should only matter
		# if the % hp remaining of two targets is tied
		if weight_sum > highest_weight:
			current_target = target_unit
			next_tile = weight_by_tiles.find_key(highest_tile_weight)
			_populate_next_tiles()
			selected_ability = owner.stats.melee_ability
			if owner.stats.melee_ability.target == Ability.TARGET.AOE:
				_populate_aoe_targets(arena)
			highest_weight = weight_sum
			in_range = true

	if not current_target:
		_find_closest_target(get_id_path, arena)


func _find_closest_target(get_id_path: Callable, arena: Arena) -> void:
	current_target = null
	in_range = false
	selected_ability = owner.stats.ranged_ability

	var shortest_distance := 99

	for target in targets_out_of_range:
		var target_unit: Unit = target["target"]
		var tiles: Array[Vector2i] = target["tiles"]
		var starting_tile: Vector2i = target["starting_tile"]

		var distance_by_tiles: Dictionary[Vector2i, int] = {}

		for tile in tiles:
			# Placeholder so it can be replaced by try_surrounding_tiles if it is not a valid
			# ending tile for enemies larger than 1 tile
			var potential_tile := tile
			var current_path: Array[Vector2i] = get_id_path.call(starting_tile, potential_tile)
			if current_path.is_empty():
				continue

			if not _valid_ending_tile(potential_tile, arena):
				var surrounding_tiles := _try_surrounding_tiles(
					potential_tile, arena, starting_tile
				)
				if surrounding_tiles.is_empty():
					continue

				var closest_surrounding_tile := tile
				var viable_path_length := 99
				var potential_path := current_path
				for surrounding_tile in surrounding_tiles:
					var surrounding_path: Array[Vector2i] = get_id_path.call(
						starting_tile, surrounding_tile
					)
					if surrounding_path.size() < viable_path_length:
						closest_surrounding_tile = surrounding_tile
						viable_path_length = surrounding_path.size()
						potential_path = surrounding_path
				if closest_surrounding_tile != tile:
					potential_tile = closest_surrounding_tile
					current_path = potential_path
				else:
					continue

			var distance := current_path.size()
			distance_by_tiles[potential_tile] = distance

			if distance < shortest_distance:
				current_target = target_unit
				next_tile = current_path[clampi(owner.stats.movement, 0, current_path.size())]
				_populate_next_tiles()
				selected_ability = owner.stats.ranged_ability
				if owner.stats.ranged_ability.target == Ability.TARGET.AOE:
					_populate_aoe_targets(arena)


func _populate_aoe_targets(arena: Arena) -> void:
	aoe_targets = []
	target_tiles = []

	if not current_target:
		return
	var target_tile := arena.get_tile_from_global(current_target.global_position)
	var delta: Vector2i = (target_tile - next_tile).abs()
	var ability := owner.stats.melee_ability if in_range else owner.stats.ranged_ability

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
			if target is Area2D:
				aoe_targets.append(target)


func _valid_ending_tile(tile: Vector2i, arena: Arena) -> bool:
	var dimensions := owner.stats.dimensions
	var valid_tiles: Array[Vector2i] = []

	for i in dimensions.x:
		for j in dimensions.y:
			var temp_x = tile.x - i
			var temp_y = tile.y - j
			if not arena.is_tile_in_bounds(Vector2i(temp_x, temp_y)):
				continue
			if arena.arena_grid.is_tile_occupied(Vector2i(temp_x, temp_y)):
				if arena.arena_grid.get_occupant(Vector2i(temp_x, temp_y)) != owner:
					continue
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

	if surrounding_tiles.is_empty():
		return []

	for surrounding_tile in surrounding_tiles:
		if not arena.is_tile_in_bounds(surrounding_tile):
			continue
		if arena.arena_grid.is_tile_occupied(surrounding_tile):
			continue
		if not _valid_ending_tile(surrounding_tile, arena):
			continue

		valid_tiles.append(surrounding_tile)
	return valid_tiles


func _populate_next_tiles() -> void:
	next_tiles = []

	if not current_target:
		return
	var dimensions = owner.stats.dimensions

	for i in dimensions.x:
		for j in dimensions.y:
			var temp_x = next_tile.x - i
			var temp_y = next_tile.y - j
			next_tiles.append(Vector2i(temp_x, temp_y))
