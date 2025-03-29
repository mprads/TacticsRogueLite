extends TileMapLayer
class_name Arena

@export var arena_grid: ArenaGrid
@export var tile_highlighter: TileHighlighter


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
	return arena_grid.tiles.has(tile)
