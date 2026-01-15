class_name ArenaGrid
extends Node

signal tile_cleanup(tile: Vector2i)

var tiles: Dictionary[Vector2i, Area2D]


func populate_grid(arena: Array[Vector2i]) -> void:
	for tile in arena:
		tiles[tile] = null


func get_tiles() -> Dictionary[Vector2i, Area2D]:
	return tiles


func add_unit(tile: Vector2i, unit: Area2D) -> void:
	tiles[tile] = unit
	unit.cleanup.connect(remove_unit.bind(tile))


func remove_unit(tile: Vector2i) -> void:
	var unit := tiles[tile]

	if not unit:
		return

	unit.cleanup.disconnect(remove_unit)
	tiles[tile] = null
	tile_cleanup.emit(tile)


func get_occupant(tile: Vector2i) -> Area2D:
	return tiles[tile]


func is_tile_occupied(tile: Vector2i) -> bool:
	return tiles[tile] != null


func get_first_empty_tile() -> Vector2i:
	for tile in tiles:
		if not is_tile_occupied(tile):
			return tile

	return Vector2i(-1, -1)


func get_random_empty_tile() -> Vector2i:
	var keys := tiles.keys()
	var tile: Vector2i = RNG.array_pick_random(keys)

	while is_tile_occupied(tile):
		keys.erase(tile)
		tile = RNG.array_pick_random(keys)

	return tile


func get_all_units() -> Array[Area2D]:
	return tiles.values().filter(func(unit): return unit)
