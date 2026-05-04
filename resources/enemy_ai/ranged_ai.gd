class_name RangedAI
extends EnemyAI


func select_target(get_id_path: Callable, arena: Arena) -> void:
	current_target = null
	in_range = false
	selected_ability = owner.stats.secondary_ability

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
			target_unit.stats.health - owner.stats.primary_ability.base_damage,
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
			if current_path.size() == 0 && Utils.get_distance_between_tiles(starting_tile, potential_tile) >= 1:
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
			in_range = true
			current_target = target_unit
			next_tile = weight_by_tiles.find_key(highest_tile_weight)
			_populate_next_tiles()
			selected_ability = owner.stats.primary_ability
			if owner.stats.primary_ability.target == Ability.TARGET.AOE_UNIT or owner.stats.primary_ability.target == Ability.TARGET.AOE_ALL:
				_populate_aoe_targets(arena)
			highest_weight = weight_sum

	if not current_target:
		_find_closest_target(get_id_path, arena)
