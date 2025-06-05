extends Node
class_name MapGenerator

const X_DIST := 150
const Y_DIST := 55
const PLACEMENT_RANDOMNESS := 5
const TOTAL_ENCOUNTERS := 15
const MAP_HEIGHT := 6
const MAX_STARTS := 5
const Min_STARTS := 3

const BREWING_ROOM_WEIGHT := 2.5
const KILN_ROOM_WEIGHT := 2.5
const SHOP_ROOM_WEIGHT := 2.5
const ELITE_ROOM_WEIGHT := 1.5
const BATTLE_ROOM_WEIGHT := 10.0

@export var battle_stats_pool: BattleStatsPool
@export var elite_battle_stats_pool: BattleStatsPool
@export var boss_battle: BattleStats

var random_room_type_weights = {
	Room.TYPE.BATTLE: 0.0,
	Room.TYPE.ELITE: 0.0,
	Room.TYPE.KILN: 0.0,
	Room.TYPE.BREWING: 0.0,
	Room.TYPE.SHOP: 0.0,
}

var random_room_type_total_weight := 0
var map_data: Array[Array]


func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()

	var starting_point := _get_random_starting_points()

	for index in starting_point:
		var current_point := index
		for i in TOTAL_ENCOUNTERS - 1:
			current_point = _setup_connection(i, current_point)

	battle_stats_pool.setup()
	elite_battle_stats_pool.setup()

	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()

	return map_data


func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []

	for i in TOTAL_ENCOUNTERS:
		var adjacent_rooms: Array[Room] = []

		for j in MAP_HEIGHT:
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_room.position = Vector2(i * X_DIST, j * Y_DIST) + offset
			current_room.row = i
			current_room.column = j
			current_room.next_rooms = []

			# For the eventual boss room
			if i == TOTAL_ENCOUNTERS - 1:
				current_room.position.x = (i + 1) * X_DIST

			adjacent_rooms.append(current_room)

		result.append(adjacent_rooms)

	return result


func _get_random_starting_points() -> Array[int]:
	var indexes: Array[int]
	var unique_points: int = 0

	while unique_points < Min_STARTS:
		unique_points = 0
		indexes = []

		for i in MAX_STARTS:
			var starting_point := RNG.instance.randi_range(0, MAP_HEIGHT - 1)
			if not indexes.has(starting_point):
				unique_points += 1

			indexes.append(starting_point)

	return indexes


func _setup_connection(row: int, column: int) -> int:
	var next_room: Room
	var current_room := map_data[row][column] as Room

	while not next_room or _would_cross_existing_path(row, column, next_room):
		var random_column := clampi(RNG.instance.randi_range(column -1, column + 1), 0, MAP_HEIGHT - 1)
		next_room = map_data[row + 1][random_column]

	current_room.next_rooms.append(next_room)

	return  next_room.column


func _would_cross_existing_path(row: int, column: int, room: Room) -> bool:
	var left_neighbour: Room
	var right_neighbour: Room

	if column > 0:
		left_neighbour = map_data[row][column - 1]
	if column < MAP_HEIGHT - 1:
		right_neighbour = map_data[row][column + 1]

	if right_neighbour and room.column > column:
		for next_room in right_neighbour.next_rooms:
			if next_room.column < room.column:
				return true

	if left_neighbour and room.column < column:
		for next_room in left_neighbour.next_rooms:
			if next_room.column > room.column:
				return true

	return false


func _setup_boss_room() -> void:
	var middle := floori(MAP_HEIGHT * 0.5)
	var boss_room := map_data[TOTAL_ENCOUNTERS - 1][middle] as Room

	for index in MAP_HEIGHT:
		var current_room = map_data[TOTAL_ENCOUNTERS - 2][index] as Room

		if current_room.next_rooms:
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)

	boss_room.type = Room.TYPE.BOSS
	boss_room.battle_stats = boss_battle


func _setup_random_room_weights() -> void:
	random_room_type_weights[Room.TYPE.BATTLE] = BATTLE_ROOM_WEIGHT
	random_room_type_weights[Room.TYPE.ELITE] = BATTLE_ROOM_WEIGHT + ELITE_ROOM_WEIGHT
	random_room_type_weights[Room.TYPE.KILN] = BATTLE_ROOM_WEIGHT + ELITE_ROOM_WEIGHT + KILN_ROOM_WEIGHT
	random_room_type_weights[Room.TYPE.BREWING] = BATTLE_ROOM_WEIGHT + ELITE_ROOM_WEIGHT + KILN_ROOM_WEIGHT + BREWING_ROOM_WEIGHT
	random_room_type_weights[Room.TYPE.SHOP] = BATTLE_ROOM_WEIGHT + ELITE_ROOM_WEIGHT + KILN_ROOM_WEIGHT + BREWING_ROOM_WEIGHT + SHOP_ROOM_WEIGHT

	random_room_type_total_weight = random_room_type_weights[Room.TYPE.SHOP]


func _setup_room_types() -> void:
	for room in map_data[0]:
		if room.next_rooms.size():
			room.type = Room.TYPE.BATTLE
			room.battle_stats = battle_stats_pool.get_battle_in_tier(0)

	for room in map_data[floori((TOTAL_ENCOUNTERS / 2) - 1)]:
		if room.next_rooms.size():
			room.type = Room.TYPE.ELITE
			room.battle_stats = elite_battle_stats_pool.get_battle_in_tier(1)

	for room in map_data[floori(TOTAL_ENCOUNTERS / 2)]:
		if room.next_rooms.size():
			room.type = Room.TYPE.KILN

	for room in map_data[TOTAL_ENCOUNTERS - 2]:
		if room.next_rooms.size():
			room.type = Room.TYPE.KILN

	for current_row in map_data:
		for room in current_row:
			for next_room in room.next_rooms:
				if next_room.type == Room.TYPE.NOT_ASSIGNED:
					_set_room_randomly(next_room)


func _set_room_randomly(room_to_set: Room) -> void:
	var early_kiln := true
	var early_brewing := true
	var consecutive_kiln := true
	var consecutive_brewing := true
	var consecutive_shop := true
	var kiln_before_half := true
	var kiln_before_boss := true

	var type_candidate: Room.TYPE

	while (early_kiln 
		or early_brewing 
		or consecutive_kiln 
		or consecutive_brewing 
		or consecutive_shop
		or kiln_before_half
		or kiln_before_boss
		):
		type_candidate = _get_random_room_type_by_weight()

		var is_kiln := type_candidate == Room.TYPE.KILN
		var has_kiln_parent := _room_has_parent_of_type(room_to_set, Room.TYPE.KILN)
		var is_brewing := type_candidate == Room.TYPE.BREWING
		var has_brewing_parent := _room_has_parent_of_type(room_to_set, Room.TYPE.BREWING)
		var is_shop := type_candidate == Room.TYPE.SHOP
		var has_shop_parent := _room_has_parent_of_type(room_to_set, Room.TYPE.SHOP)

		early_kiln = is_kiln and room_to_set.row < 3
		early_brewing = is_brewing and room_to_set.row < 3
		consecutive_kiln = is_kiln and has_kiln_parent
		consecutive_brewing = is_brewing and has_brewing_parent
		consecutive_shop = is_shop and has_shop_parent
		kiln_before_half = is_kiln and room_to_set.row == (floori(TOTAL_ENCOUNTERS / 2)) - 1
		kiln_before_boss = is_kiln and room_to_set.row == TOTAL_ENCOUNTERS - 2

	room_to_set.type = type_candidate

	if type_candidate == Room.TYPE.BATTLE:
		var battle_room_tier := 0

		if room_to_set.row > floori(TOTAL_ENCOUNTERS / 3):
			battle_room_tier = 1

		room_to_set.battle_stats = battle_stats_pool.get_battle_in_tier(battle_room_tier)
	
	if type_candidate == Room.TYPE.ELITE:
		var elite_room_tier := 0

		if room_to_set.row > floori(TOTAL_ENCOUNTERS / 3):
			elite_room_tier = 1

		room_to_set.battle_stats = elite_battle_stats_pool.get_battle_in_tier(elite_room_tier)


func _get_random_room_type_by_weight() -> Room.TYPE:
	var roll := RNG.instance.randf_range(0.0, random_room_type_total_weight)

	for type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type

	return Room.TYPE.BATTLE


func _room_has_parent_of_type(room: Room, type: Room.TYPE) -> bool:
	var parents: Array[Room] = []

	if room.column > 0 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column - 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)

	if room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)

	if room.column < MAP_HEIGHT - 1 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column + 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)

	for parent: Room in parents:
		if parent.type == type:
			return true

	return false
