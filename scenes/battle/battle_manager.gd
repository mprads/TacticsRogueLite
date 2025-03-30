extends Node2D
class_name BattleManager

@export var party_manager: PartyManager : set = set_party_manager
@export var battle_stats: BattleStats

@export var arena: Arena
@export var arena_grid: ArenaGrid
@export var bench: Arena
@export var bench_grid: ArenaGrid

@onready var enemy_manager: EnemyManager = $EnemyManager
@onready var player_manager: PlayerManager = $PlayerManager

var party: Array[UnitStats] = []
var map: BattleMap


func _ready() -> void:
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	Events.player_turn_ended.connect(_on_player_turn_ended)


func start_battle() -> void:
	player_manager.start_turn()


func generate_arena() -> void:
	if not map: return
	
	arena.tile_set = map.tile_set
	
	for tile in map.tiles:
		arena.set_cell(tile, 0, Vector2i(0, 0))
		
	arena_grid.populate_grid(map.tiles)
	
	enemy_manager.setup_enemies(battle_stats.enemies)
	enemy_manager.add_enemies_to_grid(arena_grid, arena)
	
	_grid_label_helper(map.tiles, arena)


func generate_bench() -> void:
	if not party: return
	if not map: return
	
	bench.tile_set = map.tile_set
	
	for slot in party.size():
		bench.set_cell(Vector2i(slot, 0), 0, Vector2i(1, 0))
	
	bench_grid.populate_grid(bench.get_used_cells())

	player_manager.setup_party(party)
	player_manager.add_party_to_grid(bench_grid, bench)

	_grid_label_helper(bench_grid.tiles.keys(), bench)


func set_party_manager(value: PartyManager) -> void:
	party_manager = value
	
	if not party_manager: return
	
	party =  party_manager.get_party()


func _grid_label_helper(tiles: Array[Vector2i], area: Arena) -> void:
	for tile in tiles:
		var new_label = Label.new()
		add_child(new_label)
		new_label.global_position = area.get_global_from_tile(tile) - Battle.HALF_CELL_SIZE + Vector2(0, 8)
		new_label.text = str(tile)
		new_label.modulate = Color.BLACK
		new_label.scale = Vector2(.65, .65)


func _on_enemy_turn_ended() -> void:
	player_manager.start_turn()


func _on_player_turn_ended() -> void:
	enemy_manager.start_turn()
