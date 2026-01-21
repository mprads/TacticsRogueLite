class_name PlayerManager
extends Node2D

signal change_active_unit(unit: Unit)
signal unit_selected(unit: Unit)
signal unit_aim_started(ability: Ability, unit: Unit)
signal unit_aim_stopped(unit: Unit)
signal all_units_defeated

const UNIT = preload("res://scenes/unit/unit.tscn")

@export var unit_mover: UnitMover
@export var flood_filler: FloodFiller


func _ready() -> void:
	Events.artifacts_activated.connect(_on_artifacts_activated)


func setup_party(party_stats: Array[UnitStats]) -> void:
	for unit in get_children():
		unit.queue_free()

	if party_stats.is_empty():
		return

	for stats in party_stats:
		var unit_instance := UNIT.instantiate()
		add_child(unit_instance)
		unit_instance.stats = stats
		unit_instance.turn_complete.connect(_on_unit_turn_complete)
		unit_instance.aim_started.connect(_on_unit_aim_started.bind(unit_instance))
		unit_instance.aim_stopped.connect(_on_unit_aim_stopped)
		unit_instance.request_change_active_unit.connect(_on_request_change_active_unit)
		unit_instance.unit_selected.connect(_on_unit_selected)
		unit_instance.tree_exited.connect(_on_unit_tree_exited)


func add_party_to_grid(grid: ArenaGrid, tile_map: TileMapLayer) -> void:
	for unit in get_children():
		var empty_tile = grid.get_first_empty_tile()

		grid.add_unit(empty_tile, unit)
		unit.global_position = tile_map.get_global_from_tile(empty_tile)
		unit_mover.setup_unit(unit)


func start_turn() -> void:
	for unit in get_children():
		unit.status_manager.apply_statuses_by_type(Status.TYPE.START_OF_TURN)
	Events.activate_artifacts_by_type.emit(Artifact.TYPE.START_OF_TURN)


# TODO This should be moved into the state machine and be calling a function here
func enable_drag_and_drop() -> void:
	for unit in get_children():
		if not unit.disabled and unit.moveable:
			unit.drag_and_drop.enabled = true


func disable_drag_and_drop() -> void:
	for unit in get_children():
		if not unit.disabled:
			unit.drag_and_drop.enabled = false


func _on_unit_turn_complete() -> void:
	for unit in get_children():
		if not unit.disabled:
			return

	for unit in get_children():
		unit.status_manager.apply_statuses_by_type(Status.TYPE.END_OF_TURN)

	Events.activate_artifacts_by_type.emit(Artifact.TYPE.END_OF_TURN)


func _on_request_change_active_unit(unit: Unit) -> void:
	change_active_unit.emit(unit)


func _on_unit_selected(unit: Unit) -> void:
	unit_selected.emit(unit)


func _on_unit_aim_started(ability: Ability, unit: Unit) -> void:
	unit_aim_started.emit(ability, unit)


func _on_unit_aim_stopped() -> void:
	unit_aim_stopped.emit()


func _on_unit_tree_exited() -> void:
	Events.request_update_enemy_intent.emit()
	if get_child_count() == 0:
		all_units_defeated.emit()


func _on_artifacts_activated(type: Artifact.TYPE) -> void:
	match type:
		Artifact.TYPE.START_OF_TURN:
			Events.player_turn_started.emit()
		Artifact.TYPE.END_OF_TURN:
			Events.player_turn_ended.emit()
