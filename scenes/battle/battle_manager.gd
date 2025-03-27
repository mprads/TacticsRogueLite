extends Node2D
class_name BattleManager

const UNIT = preload("res://scenes/unit/unit.tscn")

@export var party_manager: PartyManager : set = set_party_manager

@export var arena: Arena
@export var arena_grid: ArenaGrid
@export var bench: Arena
@export var bench_grid: ArenaGrid

var party: Array[UnitStats] = []
var map: BattleMap


func generate_map() -> void:
	if not map: return
	
	arena.tile_set = map.tileset
	
	for tile in map.tiles:
		arena.set_cell(tile, 0, Vector2i(0, 0))
	
	arena_grid.populate_grid(map)
	
	_add_party_to_grid(arena_grid)


func set_party_manager(value: PartyManager) -> void:
	party_manager = value
	
	if not party_manager: return
	
	party =  party_manager.get_party()


func _add_party_to_grid(grid: ArenaGrid) -> void:
	for unit_stats in party:
		var unit_instance = UNIT.instantiate()
		var empty_tile = grid.get_first_empty_tile()
		
		grid.add_child(unit_instance)
		grid.add_unit(empty_tile, unit_instance)
		unit_instance.global_position = arena.get_global_from_tile(empty_tile) - Vector2(16, 16)
		unit_instance.stats = unit_stats
