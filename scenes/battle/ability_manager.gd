class_name AbilityManager
extends Node2D

@export var arena: Arena

var aiming_unit: Unit
var current_ability: Ability


func _unhandled_input(event: InputEvent) -> void:
	if not current_ability:
		return

	if event.is_action_pressed("left_mouse"):
		if not _within_range():
			return

		match current_ability.target:
			Ability.TARGET.AOE_ALLY:
				_handle_aoe_targeting(Unit)
			Ability.TARGET.AOE_ENEMY:
				_handle_aoe_targeting(Enemy)
			Ability.TARGET.AOE_ALL:
				_handle_aoe_targeting(Area2D)



func has_active_ability() -> bool:
	return current_ability != null


func handle_unit_aim(unit: Unit, ability: Ability) -> void:
	aiming_unit = unit
	current_ability = ability

	arena.tile_highlighter.enabled = true


func handle_aim_stopped() -> void:
	aiming_unit = null
	current_ability = null

	arena.tile_highlighter.enabled = false


func handle_selected_unit(target: Unit) -> void:
	if not current_ability:
		return

	if not _within_range():
		return

	match current_ability.target:
		Ability.TARGET.SELF:
			if target == aiming_unit:
				aiming_unit.unit_state_machine.use_ability([target])
		Ability.TARGET.SINGLE_ALLY:
			if target.is_in_group("player_unit") and target != aiming_unit:
				aiming_unit.unit_state_machine.use_ability([target])
		Ability.TARGET.AOE_ALLY:
			_handle_aoe_targeting(Unit)
		Ability.TARGET.AOE_ENEMY:
			_handle_aoe_targeting(Enemy)
		Ability.TARGET.AOE_ALL:
			_handle_aoe_targeting(Area2D)


func handle_selected_enemy(target: Enemy) -> void:
	if not current_ability:
		return

	if not _within_range():
		return

	if current_ability.target == Ability.TARGET.SINGLE_ENEMY:
		if target.is_in_group("enemy_unit"):
			aiming_unit.unit_state_machine.use_ability([target])


func _handle_aoe_targeting(filter_type: Variant) -> void:
	var aoe_targets: Array[Area2D] = []
	for tile: Vector2i in arena.aoe_hovered_tiles:
		if arena.arena_grid.is_tile_occupied(tile):
			var occupant = arena.arena_grid.get_occupant(tile)
			if is_instance_of(occupant, filter_type):
				aoe_targets.append(occupant)

	if aoe_targets.is_empty():
		return

	aiming_unit.unit_state_machine.use_ability(aoe_targets)


func _within_range() -> bool:
	var aiming_tile := arena.get_tile_from_global(aiming_unit.global_position)
	var target_tile := arena.get_hovered_tile()

	var delta: Vector2i = (target_tile - aiming_tile).abs()
	var distance := int(delta.x + delta.y)

	return distance <= current_ability.max_range
