extends Node
class_name UnitMover

signal unit_moved_arenas(new_arena: Arena)

@export var arenas: Array[Arena]


func _ready() -> void:
	var units := get_tree().get_nodes_in_group("player_unit")

	for unit in units:
		setup_unit(unit)


func setup_unit(unit: Unit) -> void:
	unit.drag_and_drop.drag_started.connect(_on_unit_drag_started.bind(unit))
	unit.drag_and_drop.drag_cancelled.connect(_on_unit_drag_cancelled.bind(unit))
	unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))


func _set_highlters(enabled: bool) -> void:
	for arena in arenas:
		arena.tile_highlighter.enabled = enabled


func _get_arena_for_position(global: Vector2) -> int:
	var dropped_area_index := -1
	
	for i in arenas.size():
		var tile := arenas[i].get_tile_from_global(global)
		if arenas[i].is_tile_in_bounds(tile):
			dropped_area_index = i

	return dropped_area_index


func _reset_unit_to_starting_position(starting_position: Vector2, unit: Unit) -> void:
	var i := _get_arena_for_position(starting_position)
	var tile := arenas[i].get_tile_from_global(starting_position)
	 
	unit.global_position = starting_position
	arenas[i].arena_grid.add_unit(tile, unit)


func _move_unit(unit: Unit, arena: Arena, tile: Vector2i) -> void:
	arena.arena_grid.add_unit(tile, unit)
	unit.global_position = arena.get_global_from_tile(tile)


func _on_unit_drag_started(unit: Unit) -> void:
	_set_highlters(true)
	var i := _get_arena_for_position(unit.global_position)

	if i > -1:
		var tile := arenas[i].get_tile_from_global(unit.global_position)
		arenas[i].arena_grid.remove_unit(tile)


func _on_unit_drag_cancelled(starting_position: Vector2, unit: Unit) -> void:
	_set_highlters(false)
	_reset_unit_to_starting_position(starting_position, unit)


func _on_unit_dropped(starting_position: Vector2, unit: Unit) -> void:
	_set_highlters(false)
	
	var old_arena_index := _get_arena_for_position(starting_position)
	var drop_arena_index := _get_arena_for_position(unit.get_global_mouse_position())

	if drop_arena_index == -1:
		_reset_unit_to_starting_position(starting_position, unit)
		return
	
	var old_arena := arenas[old_arena_index]
	#var old_tile := old_arena.get_tile_from_global(starting_position)
	var new_arena := arenas[drop_arena_index]
	var new_tile := new_arena.get_hovered_tile()

	
	if new_arena.arena_grid.is_tile_occupied(new_tile):
		_reset_unit_to_starting_position(starting_position, unit)
		# TODO only enable swapping places during unit placement
		#var old_unit: Unit = new_arena.arena_grid.tiles[new_tile]
		#new_arena.arena_grid.remove_unit(new_tile)
		#_move_unit(old_unit, old_arena, old_tile)
	else :
		_move_unit(unit, new_arena, new_tile)
		
		if new_arena != old_arena:
			unit_moved_arenas.emit(new_arena)
