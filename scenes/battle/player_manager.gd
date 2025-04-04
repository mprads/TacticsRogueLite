extends Node2D
class_name PlayerManager

const UNIT = preload("res://scenes/unit/unit.tscn")

@export var unit_mover: UnitMover
@export var flood_filler: FloodFiller


func setup_party(party_stats: Array[UnitStats]) -> void:
	for unit in get_children():
		unit.queue_free()

	if party_stats.is_empty(): return
	
	for stats in party_stats:
		var unit_instance := UNIT.instantiate()
		add_child(unit_instance)
		unit_instance.stats = stats
		unit_instance.turn_complete.connect(_on_unit_turn_complete)
		unit_instance.aim_started.connect(_on_unit_aim_started.bind(unit_instance))
		unit_instance.aim_stopped.connect(_on_unit_aim_stopped)


func add_party_to_grid(grid: ArenaGrid, tile_map: TileMapLayer) -> void:
	for unit in get_children():
		var empty_tile = grid.get_first_empty_tile()
		
		grid.add_unit(empty_tile, unit)
		unit.global_position = tile_map.get_global_from_tile(empty_tile)
		unit_mover.setup_unit(unit)


func start_turn() -> void:
	Events.player_turn_started.emit()


func _on_unit_turn_complete() -> void:
	for unit in get_children():
		if not unit.disabled: return
	
	Events.player_turn_ended.emit()


func _on_unit_aim_started(ability: Ability, unit: Unit) -> void:
	flood_filler.enabled = true
	var i := unit_mover.get_arena_for_position(unit.global_position)
	var tile := unit_mover.arenas[i].get_tile_from_global(unit.global_position)
	flood_filler.flood_fill_from_tile(tile, ability.max_range, false, ability.atlas_coord)


func _on_unit_aim_stopped() -> void:
	flood_filler.clear()
	flood_filler.enabled = false
