extends Node2D
class_name PlayerManager

const UNIT = preload("res://scenes/unit/unit.tscn")

@export var unit_mover: UnitMover


func setup_party(party_stats: Array[UnitStats]) -> void:
	for unit in get_children():
		unit.queue_free()

	if party_stats.is_empty(): return
	
	for stats in party_stats:
		var unit_instance := UNIT.instantiate()
		add_child(unit_instance)
		unit_instance.stats = stats


func add_party_to_grid(grid: ArenaGrid, tile_map: TileMapLayer) -> void:
	for unit in get_children():
		var empty_tile = grid.get_first_empty_tile()
		
		grid.add_unit(empty_tile, unit)
		unit.global_position = tile_map.get_global_from_tile(empty_tile)
		unit_mover.setup_unit(unit)
