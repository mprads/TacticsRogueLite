extends Resource
class_name EnemyAI

var owner: Enemy
var targets_in_range: Array[Dictionary]
var targets_out_of_range: Array[Dictionary]
var current_target: Unit
var next_tile: Vector2i
var in_range := false


func select_target(get_id_path: Callable, _arena: Arena) -> void:
	current_target = null

	if targets_in_range.is_empty():
		_find_closest_target(get_id_path, _arena)
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
		var new_health: int = clampi(target_unit.stats.health - owner.stats.melee_ability.base_damage, 0, target_unit.stats.health)
		var remaining_percent := float(new_health) / target_unit.stats.max_health

		var damage_weight = 1 - remaining_percent

		var weight_by_tiles: Dictionary[Vector2i, float] = {}
		var highest_tile_weight := 0.0

		# For each tile in range of target unit check the distance to starting tile
		# weight less movement higher
		for tile in tiles:
			var temp_path: Array[Vector2i] = get_id_path.call(starting_tile, tile)
			if temp_path.size() - 1 > owner.stats.movement: continue

			var distance := temp_path.size()
			var max_weight := (float(owner.stats.movement) / 100) + 0.1
			var movement_weight := max_weight - (float(distance) / 100)

			weight_by_tiles[tile] = movement_weight

			if movement_weight > highest_tile_weight:
				highest_tile_weight = movement_weight

		var weight_sum = damage_weight + highest_tile_weight

		if weight_by_tiles.is_empty() or highest_tile_weight == 0.0: continue

		# Should target the unit it can put the closest to low % hp, movement should only matter 
		# if the % hp remaining of two targets is tied
		if weight_sum > highest_weight:
			current_target = target_unit
			next_tile = weight_by_tiles.find_key(highest_tile_weight)
			in_range = true

			highest_weight = weight_sum

	if not current_target:
		_find_closest_target(get_id_path, _arena)


func _find_closest_target(get_id_path: Callable, _arena: Arena) -> void:
	current_target = null
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
