extends Node2D
class_name BattleManager

const UNIT = preload("res://scenes/unit/unit.tscn")

@export var party_manager: PartyManager : set = set_party_manager

@export var arena: Arena
@export var arena_grid: ArenaGrid
@export var bench: Arena
@export var bench_grid: ArenaGrid

@onready var unit_mover: UnitMover = $UnitMover

var party: Array[UnitStats] = []
var map: BattleMap


func generate_arena() -> void:
	if not map: return
	
	arena.tile_set = map.tile_set
	
	for tile in map.tiles:
		var new_label = Label.new()
		add_child(new_label)
		new_label.global_position = arena.get_global_from_tile(tile) - Battle.HALF_CELL_SIZE
		new_label.text = str(tile)
		new_label.scale = Vector2(.8, .8)
		arena.set_cell(tile, 0, Vector2i(0, 0))
	
	arena_grid.populate_grid(map.tiles)


func generate_bench() -> void:
	if not party: return
	if not map: return
	
	bench.tile_set = map.tile_set
	
	for slot in party.size():
		bench.set_cell(Vector2i(slot, 0), 0, Vector2i(1, 0))
		var new_label = Label.new()
		add_child(new_label)
		new_label.global_position = bench.get_global_from_tile(Vector2i(slot, 0)) - Battle.HALF_CELL_SIZE
		new_label.text = str(Vector2i(slot, 0))
		new_label.scale = Vector2(.8, .8)
	
	bench_grid.populate_grid(bench.get_used_cells())
	_add_party_to_grid(bench_grid, bench)


func set_party_manager(value: PartyManager) -> void:
	party_manager = value
	
	if not party_manager: return
	
	party =  party_manager.get_party()


func _add_party_to_grid(grid: ArenaGrid, tile_map: TileMapLayer) -> void:
	for unit_stats in party:
		var unit_instance = UNIT.instantiate()
		var empty_tile = grid.get_first_empty_tile()
		
		grid.add_child(unit_instance)
		grid.add_unit(empty_tile, unit_instance)
		unit_instance.global_position = tile_map.get_global_from_tile(empty_tile) - Vector2(16, 16)
		unit_instance.stats = unit_stats
		unit_mover.setup_unit(unit_instance)
