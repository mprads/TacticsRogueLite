extends Node
class_name UnitMover

signal unit_moved_arenas()

@export var arenas: Array[Arena]
@export var navigation: Navigation

var dragging := false


func setup_unit(unit: Unit) -> void:
	unit.drag_and_drop.drag_started.connect(_on_unit_drag_started.bind(unit))
	unit.drag_and_drop.drag_cancelled.connect(_on_unit_drag_cancelled.bind(unit))
	unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))


func setup_enemy(enemy: Enemy) -> void:
	enemy.request_enemy_move.connect(_on_enemy_request_move.bind(enemy))


func is_dragging() -> bool:
	return dragging


func get_arena_for_position(global: Vector2) -> int:
	var dropped_area_index := -1

	for i in arenas.size():
		var tile := arenas[i].get_tile_from_global(global)
		if arenas[i].is_tile_in_bounds(tile):
			dropped_area_index = i

	return dropped_area_index


func get_id_path(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	return navigation.create_id_path(start, end)


func _set_highlters(enabled: bool) -> void:
	for arena in arenas:
		arena.tile_highlighter.enabled = enabled


func _set_flood_fillers(enabled: bool) -> void:
	for arena in arenas:
		if arena.player_flood_filler:
			arena.player_flood_filler.enabled = enabled


func _reset_unit_to_starting_position(starting_position: Vector2, unit: Unit) -> void:
	var i := get_arena_for_position(starting_position)
	var tile := arenas[i].get_tile_from_global(starting_position)
 
	unit.global_position = starting_position
	arenas[i].arena_grid.add_unit(tile, unit)
	unit.movement_cancelled.emit()


func _move_unit(unit: Node, arena: Arena, tile: Vector2i) -> void:
	arena.arena_grid.add_unit(tile, unit)
	navigation.set_id_occupied(tile)
	unit.global_position = arena.get_global_from_tile(tile)
	unit.move_cleanup()
	Events.request_update_enemy_intent.emit()


func _move_along_path(unit: Node, arena: Arena, path: Array[Vector2i]) -> void:
	var current_tile: Vector2i = path.pop_front()
	
	if not current_tile and path.is_empty():
		unit.move_cleanup()
		return

	if not path.is_empty():
		arena.arena_grid.remove_unit(current_tile)
		arena.arena_grid.add_unit(path[0], unit)
		unit.global_position = arena.get_global_from_tile(path[0])
		await get_tree().create_timer(.25).timeout
		_move_along_path(unit, arena, path)
	else:
		navigation.set_id_occupied(current_tile)
		unit.move_cleanup()


func _on_unit_drag_started(unit: Unit) -> void:
	dragging = true
	_set_highlters(true)
	_set_flood_fillers(true)
	var i := get_arena_for_position(unit.global_position)

	if i > -1:
		var tile := arenas[i].get_tile_from_global(unit.global_position)
		arenas[i].arena_grid.remove_unit(tile)

		if arenas[i].player_flood_filler:
			arenas[i].player_flood_filler.flood_fill_from_tile(tile, unit.stats.movement, true, Vector2i(1, 0))


func _on_unit_drag_cancelled(starting_position: Vector2, unit: Unit) -> void:
	dragging = false
	_set_highlters(false)
	_set_flood_fillers(false)
	_reset_unit_to_starting_position(starting_position, unit)


func _on_unit_dropped(starting_position: Vector2, unit: Unit) -> void:
	dragging = false
	_set_highlters(false)
	_set_flood_fillers(false)

	var old_arena_index := get_arena_for_position(starting_position)
	var drop_arena_index := get_arena_for_position(unit.get_global_mouse_position())

	if drop_arena_index == -1:
		_reset_unit_to_starting_position(starting_position, unit)
		return

	var old_arena := arenas[old_arena_index]
	var old_tile := old_arena.get_tile_from_global(starting_position)
	var new_arena := arenas[drop_arena_index]
	var new_tile := new_arena.get_hovered_tile()

	if new_tile == old_tile and new_arena == old_arena:
		_reset_unit_to_starting_position(starting_position, unit)

	if new_arena == old_arena:
		var distance := Utils.get_distance_between_tiles(old_tile, new_tile)

		if distance > unit.stats.movement:
			_reset_unit_to_starting_position(starting_position, unit)
			return

	if new_arena.arena_grid.is_tile_occupied(new_tile):
		_reset_unit_to_starting_position(starting_position, unit)
		# TODO only enable swapping places during unit placement
		#var old_unit: Unit = new_arena.arena_grid.get_tiles()[new_tile]
		#new_arena.arena_grid.remove_unit(new_tile)
		#_move_unit(old_unit, old_arena, old_tile)
	else :
		_move_unit(unit, new_arena, new_tile)

		if new_arena != old_arena:
			unit_moved_arenas.emit()
		else:
			navigation.set_id_empty(old_tile)


func _on_enemy_request_move(new_tile: Vector2i, enemy: Enemy) -> void:
	var i := get_arena_for_position(enemy.global_position)
	var tile := arenas[i].get_tile_from_global(enemy.global_position)

	var id_path := navigation.create_id_path(tile, new_tile)

	navigation.set_id_empty(tile)
	_move_along_path(enemy, arenas[i], id_path)
