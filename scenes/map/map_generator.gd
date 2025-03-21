@tool
extends Node
class_name MapGenerator

const X_DIST := 30
const Y_DIST := 25
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 15
const MAP_WIDTH := 7
const PATHS := 6
const KILN_ROOM_WEIGHT := 4.0
const BREWING_ROOM_WEIGHT := 4.0
const SHOP_ROOM_WEIGHT := 2.5
const BATTLE_ROOM_WEIGHT := 10.0

var random_room_type_weights = {
	Room.Type.KILN: 0.0,
	Room.Type.BREWING: 0.0,
	Room.Type.SHOP: 0.0,
	Room.Type.BATTLE: 0.0,
}

var random_room_type_total_weight := 0
var map_data: Array[Array]


func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_point := _get_random_starting_points()
	
	for j in starting_point:
		var current_j := j
		for i in FLOORS -1:
			current_j = _setup_connection(i, current_j)
	
	_setup_random_room_weights()
	_setup_room_types()
	
	return map_data


func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in FLOORS:
		var adjacent_rooms: Array[Room] = []
		
		for j in MAP_WIDTH:
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_room.position = Vector2(j * X_DIST, i * -Y_DIST) + offset
			current_room.row = i
			current_room.column = j
			current_room.next_rooms = []
			
			if i == FLOORS - 1:
				current_room.position.y = (i + 1) * -Y_DIST
			
			adjacent_rooms.append(current_room)
	
		result.append(adjacent_rooms)
	
	return result


func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	while unique_points < 2:
		unique_points = 0
		y_coordinates = []
		
		for i in PATHS:
			var starting_point := randi_range(0, MAP_WIDTH - 1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
				
			y_coordinates.append(starting_point)
			
	return y_coordinates


func _setup_connection(i: int, j: int) -> int:
	var next_room: Room
	var current_room := map_data[i][j] as Room
	
	while not next_room or  _would_cross_existing_path(i, j, next_room):
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
		next_room = map_data[i + 1][random_j]
		
	current_room.next_rooms.append(next_room)
	
	return next_room.column


func _would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	var left_neighbour: Room
	var right_neighbour: Room
	
	if j > 0:
		left_neighbour = map_data[i][j - 1]
	if j < MAP_WIDTH - 1:
		right_neighbour = map_data[i][j+1]
	
	if right_neighbour and room.column > j:
		for next_room: Room in right_neighbour.next_rooms:
			if next_room.column < room.column:
				return true

	if left_neighbour and room.column < j:
		for next_room: Room in left_neighbour.next_rooms:
			if next_room.column > room.column:
				return true

	return false


func _setup_random_room_weights() -> void:
	random_room_type_weights[Room.Type.BATTLE] = BATTLE_ROOM_WEIGHT
	random_room_type_weights[Room.Type.KILN] = KILN_ROOM_WEIGHT + BATTLE_ROOM_WEIGHT
	random_room_type_weights[Room.Type.BREWING] = BATTLE_ROOM_WEIGHT + KILN_ROOM_WEIGHT + BREWING_ROOM_WEIGHT
	random_room_type_weights[Room.Type.SHOP] = BATTLE_ROOM_WEIGHT+ KILN_ROOM_WEIGHT + BREWING_ROOM_WEIGHT + SHOP_ROOM_WEIGHT

	random_room_type_total_weight = random_room_type_weights[Room.Type.SHOP]


func _setup_room_types() -> void:
	for room: Room in map_data[0]:
		if room.next_rooms.size():
			room.type = Room.Type.BATTLE

	for room: Room in map_data[floori(FLOORS / 2)]:
		if room.next_rooms.size():
			room.type = Room.Type.BREWING

	for room: Room in map_data[FLOORS - 2]:
		if room.next_rooms.size():
			room.type = Room.Type.KILN

	for current_floor in map_data:
		for room: Room in current_floor:
			for next_room: Room in room.next_rooms:
				if next_room.type == Room.Type.NOT_ASSIGNED:
					_set_room_randomly(next_room)


func _set_room_randomly(room_to_set: Room) -> void:
	var kiln_below_4 := true
	var consecutive_kiln := true
	var consecutive_shop := true
	var kiln_on_13 := true

	var type_candidate: Room.Type
	
	while kiln_below_4 or consecutive_kiln or consecutive_shop or kiln_on_13:
		type_candidate = _get_random_room_type_by_weight()
		
		var is_kiln := type_candidate == Room.Type.KILN
		var has_kiln_parent := _room_has_parent_of_type(room_to_set, Room.Type.KILN)
		var is_shop := type_candidate == Room.Type.SHOP
		var has_shop_parent := _room_has_parent_of_type(room_to_set, Room.Type.SHOP)

		kiln_below_4 = is_kiln and room_to_set.row < 3
		consecutive_kiln = is_kiln and has_kiln_parent
		consecutive_shop = is_shop and has_shop_parent
		kiln_on_13 = is_kiln and room_to_set.row == FLOORS - 2
	
	room_to_set.type = type_candidate
	
	if type_candidate == Room.Type.BATTLE:
		if room_to_set.row > floori(FLOORS / 3):
			#TODO Increase difficulty of battle based on rooms traveled
			pass


func _get_random_room_type_by_weight() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weight)
	
	for type: Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
	
	return Room.Type.BATTLE


func _room_has_parent_of_type(room: Room, type: Room.Type) -> bool:
	var parents: Array[Room] = []
	
	if room.column > 0 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column - 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
			
	if room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
			
	if room.column < MAP_WIDTH - 1 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column + 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
			
	for parent: Room in parents:
		if parent.type == type:
			return true

	return false
