class_name BattleManager
extends Node2D

@export var party_manager: PartyManager:
	set = set_party_manager
@export var battle_stats: BattleStats

@export var arena: Arena
@export var arena_grid: ArenaGrid
@export var bench: Arena
@export var bench_grid: ArenaGrid

@onready var enemy_manager: EnemyManager = $EnemyManager
@onready var player_manager: PlayerManager = $PlayerManager
@onready var ability_manager: AbilityManager = $AbilityManager
@onready var unit_mover: UnitMover = $UnitMover
@onready var navigation: Navigation = $Navigation
@onready var target_selector_ui: TargetSelectorUI = $TargetSelectorUI
@onready var enemy_target_selector_ui: TargetSelectorUI = $EnemyTargetSelectorUI

@onready var party_selection_container: VBoxContainer = %PartySelectionContainer
@onready var unit_context_menu: Control = %UnitContextMenu
@onready var start_battle_button: Button = %StartBattleButton

var party: Array[UnitStats] = []
var map: BattleMap


func _ready() -> void:
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	Events.player_turn_ended.connect(_on_player_turn_ended)
	player_manager.change_active_unit.connect(_on_change_active_unit)
	player_manager.unit_selected.connect(_on_unit_selected)
	player_manager.unit_aim_started.connect(_on_unit_aim_started)
	player_manager.unit_aim_stopped.connect(_on_unit_aim_stopped)
	player_manager.all_units_defeated.connect(_on_player_manager_all_units_defeated)
	enemy_manager.enemy_selected.connect(_on_enemy_selected)
	enemy_manager.show_enemy_intent.connect(_on_show_enemy_intent)
	enemy_manager.request_clear_intent.connect(_on_request_clear_intent)
	enemy_manager.all_enemies_defeated.connect(_on_enemy_manager_all_enemies_defeated)
	unit_mover.unit_moved_arenas.connect(_on_unit_moved_arenas)
	start_battle_button.pressed.connect(_on_start_battle_pressed)

	for child in party_selection_container.get_children():
		child.queue_free()


func start_deployment() -> void:
	_generate_bench()
	start_battle_button.disabled = true
	start_battle_button.show()


func generate_arena() -> void:
	if not map:
		return

	arena.clear()

	arena.tile_set = map.tile_set

	var coords: Array[Vector2i] = []
	for tile in map.tiles:
		arena.set_cell(tile.coord, tile.source_id, tile.atlas_coord)
		coords.append(tile.coord)

	arena_grid.populate_grid(coords)
	navigation.init(arena.get_used_rect(), coords)

	enemy_manager.setup_enemies(battle_stats.enemies)
	enemy_manager.add_enemies_to_grid(arena_grid, arena)

	_grid_label_helper(coords, arena)


func set_party_manager(value: PartyManager) -> void:
	party_manager = value

	if not party_manager:
		return

	party = party_manager.get_party()


func _generate_bench() -> void:
	if not party:
		return
	if not map:
		return

	bench.clear()

	bench.tile_set = map.tile_set

	for slot in party.size():
		bench.set_cell(Vector2i(slot, 0), 0, Vector2i(1, 0))

	bench_grid.populate_grid(bench.get_used_cells())

	player_manager.setup_party(party)
	player_manager.add_party_to_grid(bench_grid, bench)

	# TODO Remove
	_grid_label_helper(bench_grid.tiles.keys(), bench)


func _start_battle() -> void:
	unit_mover.unit_moved_arenas.disconnect(_on_unit_moved_arenas)
	var not_deployed := bench_grid.get_all_units()
	for unit in not_deployed:
		unit.queue_free()
		await unit.tree_exited

	party_selection_container.create_unit_select_buttons(player_manager.get_children())
	party_selection_container.unit_selected.connect(_on_change_active_unit)

	for enemy in enemy_manager.get_children():
		enemy_manager.verify_intent(enemy)

	unit_context_menu.unit = null
	Events.activate_artifacts_by_type.emit(Artifact.TYPE.START_OF_COMBAT)
	player_manager.start_turn()


# TODO remove
func _grid_label_helper(tiles: Array[Vector2i], area: Arena) -> void:
	for tile in tiles:
		var new_label = Label.new()
		add_child(new_label)
		new_label.global_position = (
			area.get_global_from_tile(tile) - Battle.HALF_CELL_SIZE + Vector2(0, 8)
		)
		new_label.text = str(tile)
		new_label.modulate = Color.BLACK


func _on_enemy_turn_ended() -> void:
	if player_manager.get_child_count() == 0:
		return
	player_manager.start_turn()


func _on_enemy_manager_all_enemies_defeated() -> void:
	Events.activate_artifacts_by_type.emit(Artifact.TYPE.END_OF_COMBAT)
	Events.battle_won.emit()


func _on_player_turn_ended() -> void:
	unit_context_menu.unit = null

	if enemy_manager.get_child_count() == 0:
		return
	enemy_manager.start_turn()


func _on_player_manager_all_units_defeated() -> void:
	Events.activate_artifacts_by_type.emit(Artifact.TYPE.END_OF_COMBAT)
	Events.battle_lost.emit()


func _on_start_battle_pressed() -> void:
	start_battle_button.hide()
	unit_mover.arenas.erase(bench)
	bench.queue_free()
	_start_battle()


func _on_unit_moved_arenas() -> void:
	var has_unit = arena_grid.get_all_units().filter(func(entity): return entity is Unit).is_empty()

	if has_unit:
		start_battle_button.disabled = true
	else:
		start_battle_button.disabled = false


func _on_change_active_unit(unit: Unit) -> void:
	if ability_manager.has_active_ability():
		return

	unit_context_menu.unit = unit


func _on_unit_aim_started(ability: Ability, unit: Unit) -> void:
	arena.enable_flood_filler("PLAYER")
	target_selector_ui.enabled = true
	target_selector_ui.starting_position = unit.global_position
	var i := unit_mover.get_arena_for_position(unit.global_position)
	var tile := unit_mover.arenas[i].get_tile_from_global(unit.global_position)
	arena.player_flood_filler.flood_fill_from_tile(
		tile, ability.max_range, false, ability.atlas_coord
	)
	player_manager.disable_drag_and_drop()
	ability_manager.handle_unit_aim(unit, ability)


func _on_unit_aim_stopped() -> void:
	arena.clear_flood_filler("PLAYER")
	target_selector_ui.enabled = false
	target_selector_ui.starting_position = Vector2.ZERO
	player_manager.enable_drag_and_drop()
	ability_manager.handle_aim_stopped()
	unit_context_menu.unit = null


func _on_unit_selected(unit: Unit) -> void:
	ability_manager.handle_selected_unit(unit)

	if not unit.disabled:
		unit_context_menu.unit = unit


func _on_show_enemy_intent(enemy: Enemy) -> void:
	if enemy.stats.dimensions.x * enemy.stats.dimensions.y > 1:
		for tile in enemy.ai.next_tiles:
			arena.enemy_flood_filler.fill_tile(tile, Vector2i(2, 2))
	else:
		arena.enemy_flood_filler.fill_tile(enemy.ai.next_tile, Vector2i(2, 2))

	if enemy.ai.selected_ability.target == Ability.TARGET.AOE:
		for tile in enemy.ai.target_tiles:
			arena.enemy_flood_filler.fill_tile(tile, Vector2i(2, 1))
	else:
		enemy_target_selector_ui.starting_position = enemy.global_position
		enemy_target_selector_ui.ending_position = enemy.ai.current_target.global_position


func _on_request_clear_intent() -> void:
	enemy_target_selector_ui.starting_position = Vector2.ZERO
	enemy_target_selector_ui.ending_position = Vector2.ZERO


func _on_enemy_selected(enemy: Enemy) -> void:
	ability_manager.handle_selected_enemy(enemy)
	_on_request_clear_intent()
