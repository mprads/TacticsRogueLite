extends Node
class_name ArenaGrid

signal arena_grid_changed

var tiles: Dictionary[Vector2i, Node]


func populate_grid(arena: Array[Vector2i]) -> void:
	for tile in arena:
		tiles[tile] = null


func get_tiles() ->  Dictionary[Vector2i, Node]:
	return tiles


func add_unit(tile: Vector2i, unit: Node) -> void:
	tiles[tile] = unit
	arena_grid_changed.emit()


func remove_unit(tile: Vector2i) -> void:
	var unit := tiles[tile]

	if not unit: return
	tiles[tile] = null
	arena_grid_changed.emit()


func is_tile_occupied(tile: Vector2i) -> bool:
	return tiles[tile] != null


func get_first_empty_tile() -> Vector2i:
	for tile in tiles:
		if not is_tile_occupied(tile):
			return tile

	return Vector2i(-1, -1)


func get_random_empty_tile() -> Vector2i:
	var keys := tiles.keys()
	var tile: Vector2i = keys.pick_random()
	
	while is_tile_occupied(tile):
		keys.erase(tile)
		tile = keys.pick_random()

	return tile


func get_all_units() -> Array[Node]:
	return tiles.values().filter(func(unit): return unit)
