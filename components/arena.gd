extends TileMapLayer
class_name Arena

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

@export var arena_grid: ArenaGrid
@export var tile_highlighter: TileHighlighter
@export var player_flood_filler: FloodFiller
@export var enemy_flood_filler: FloodFiller


func _process(_delta: float) -> void:
	if not tile_highlighter.enabled: return
	
	var selected_tile := get_hovered_tile()
	
	if not is_tile_in_bounds(selected_tile):
		tile_highlighter.clear()
		return
	
	tile_highlighter._update_tile(selected_tile)


func get_tile_from_global(global: Vector2) -> Vector2i:
	return local_to_map(to_local(global))


func get_global_from_tile(tile: Vector2i) -> Vector2:
	return to_global(map_to_local(tile))


func get_hovered_tile() -> Vector2i:
	return local_to_map(get_local_mouse_position())


func is_tile_in_bounds(tile: Vector2i) -> bool:
	return arena_grid.get_tiles().has(tile)


func get_neighbour_tiles(tile: Vector2i) -> Array[Vector2i]:
	var results: Array[Vector2i] = []
	
	for direction in DIRECTIONS:
		if is_tile_in_bounds(tile + direction):
			results.append(tile + direction)
	
	return results


# I hate check the string, the battle manager passing a reference seems incorrect
# and an enum seems overkill
func enable_flood_filler(layer: String) -> void:
	match layer:
		"PLAYER":
			player_flood_filler.enabled = true
		"ENEMY":
			enemy_flood_filler.enabled = true
		_:
			pass


func clear_flood_filler(layer: String) -> void:
	match layer:
		"PLAYER":
			player_flood_filler.enabled = false
		"ENEMY":
			enemy_flood_filler.enabled = false
		_:
			pass
	
