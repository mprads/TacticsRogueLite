extends Node2D
class_name BattleManager

const UNIT_SELECT_BUTTON = preload("res://scenes/ui/battle/unit_select_button.tscn")

@export var party_manager: PartyManager : set = set_party_manager
@export var battle_stats: BattleStats

@export var arena: Arena
@export var arena_grid: ArenaGrid
@export var bench: Arena
@export var bench_grid: ArenaGrid

@onready var enemy_manager: EnemyManager = $EnemyManager
@onready var player_manager: PlayerManager = $PlayerManager
@onready var unit_mover: UnitMover = $UnitMover

@onready var party_selection_container: VBoxContainer = %PartySelectionContainer
@onready var unit_context_menu: Control = %UnitContextMenu
@onready var start_battle_button: Button = %StartBattleButton

var party: Array[UnitStats] = []
var map: BattleMap


func _ready() -> void:
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	Events.player_turn_ended.connect(_on_player_turn_ended)
	unit_mover.unit_moved_arenas.connect(_on_unit_moved_arenas)
	start_battle_button.pressed.connect(_on_start_battle_pressed)

	for child in party_selection_container.get_children():
		child.queue_free()


func start_deployment() -> void:
	_generate_bench()
	start_battle_button.disabled = true
	start_battle_button.show()


func generate_arena() -> void:
	if not map: return
	
	arena.clear()
	
	arena.tile_set = map.tile_set
	
	for tile in map.tiles:
		arena.set_cell(tile, 0, Vector2i(0, 0))
		
	arena_grid.populate_grid(map.tiles)
	
	enemy_manager.setup_enemies(battle_stats.enemies)
	enemy_manager.add_enemies_to_grid(arena_grid, arena)
	
	_grid_label_helper(map.tiles, arena)


func set_party_manager(value: PartyManager) -> void:
	party_manager = value
	
	if not party_manager: return
	
	party =  party_manager.get_party()


func _generate_bench() -> void:
	if not party: return
	if not map: return
	
	bench.clear()
	
	bench.tile_set = map.tile_set
	
	for slot in party.size():
		bench.set_cell(Vector2i(slot, 0), 0, Vector2i(1, 0))
	
	bench_grid.populate_grid(bench.get_used_cells())

	player_manager.setup_party(party)
	player_manager.add_party_to_grid(bench_grid, bench)

	_grid_label_helper(bench_grid.tiles.keys(), bench)


func _start_battle() -> void:
	unit_mover.unit_moved_arenas.disconnect(_on_unit_moved_arenas)
	var not_deployed := bench_grid.get_all_units()
	for unit in not_deployed:
		unit.queue_free()
		await unit.tree_exited

	for unit in player_manager.get_children():
		var selection_ui_instance := UNIT_SELECT_BUTTON.instantiate()
		party_selection_container.add_child(selection_ui_instance)
		selection_ui_instance.unit = unit

	player_manager.start_turn()


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


func _on_start_battle_pressed() -> void:
	start_battle_button.hide()
	bench.visible = false
	_start_battle()


func _on_unit_moved_arenas(new_arena: Arena) -> void:
	var has_unit = arena_grid.get_all_units().filter(func(entity): return entity is Unit).is_empty()

	if has_unit:
		start_battle_button.disabled = true
	else:
		start_battle_button.disabled = false
