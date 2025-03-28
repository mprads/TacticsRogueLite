extends Node
class_name TileHighlighter

@export var enabled: bool = true :  set = _set_enabled
@export var arena: Arena
@export var highlight_layer: TileMapLayer
@export var tile: Vector2i


func _process(_delta: float) -> void:
	if not enabled: return
	
	var selected_tile := arena.get_hovered_tile()
	
	if not arena.is_tile_in_bounds(selected_tile):
		highlight_layer.clear()
		return
	
	_update_tile(selected_tile)


func _update_tile(selected_tile: Vector2i) -> void:
	highlight_layer.clear()
	highlight_layer.set_cell(selected_tile, arena.tile_set.get_source_id(0), tile)


func _set_enabled(value: bool) -> void:
	enabled = value
	
	if not enabled and arena:
		highlight_layer.clear()
