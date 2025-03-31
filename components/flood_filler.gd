extends Node
class_name FloodFiller

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

@export var enabled: bool = true :  set = set_enabled
@export var fill_layer: TileMapLayer
@export var arena_grid: ArenaGrid

var move_fill_tile_coords := Vector2i(3, 0)
var attack_fill_tile_coords := Vector2i(4, 0)


func clear() -> void:
	fill_layer.clear()


func flood_fill_from_tile(starting_tile: Vector2i, max_distance: int, exclude_occupied: bool) -> void:
	var tiles: Array[Vector2i] = []
	var queue: Array[Vector2i] = [starting_tile]
	
	while not queue.is_empty():
		var current_tile: Vector2i = queue.pop_back()
		
		if tiles.has(current_tile):
			continue
		elif not arena_grid.get_tiles().has(current_tile):
			continue
		elif exclude_occupied and arena_grid.is_tile_occupied(current_tile):
			continue
		
		var delta: Vector2i = (current_tile - starting_tile).abs()
		var distance := int(delta.x + delta.y)
		
		if distance > max_distance:
			continue
		
		tiles.append(current_tile)
		
		for direction in DIRECTIONS:
			var next_tile: Vector2i = current_tile + direction
			
			if arena_grid.get_tiles().has(next_tile) and arena_grid.is_tile_occupied(next_tile):
				continue
			elif tiles.has(next_tile):
				continue
			
			queue.append(next_tile)
		
	for tile in tiles:
		fill_tile(tile, move_fill_tile_coords)


func fill_tile(coords: Vector2i, tile: Vector2i) -> void:
	fill_layer.set_cell(coords, fill_layer.tile_set.get_source_id(0), tile)


func set_enabled(value: bool) -> void:
	enabled = value
	
	if not enabled:
		fill_layer.clear()
