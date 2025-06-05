class_name TileHighlighter
extends Node

@export var enabled: bool = true:
	set = set_enabled
@export var highlight_layer: TileMapLayer
@export var tile: Vector2i


func clear() -> void:
	highlight_layer.clear()


func set_enabled(value: bool) -> void:
	enabled = value

	if not enabled:
		highlight_layer.clear()


func _update_tile(selected_tile: Vector2i) -> void:
	highlight_layer.clear()
	highlight_layer.set_cell(selected_tile, highlight_layer.tile_set.get_source_id(0), tile)
