extends Node2D
class_name AbilityManager

@export var arena: Arena

var aiming_unit: Unit
var current_ability: Ability


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
	if not current_ability: return
	if not _within_range(target): return
	
	match current_ability.target:
		Ability.TARGET.SELF:
			if target == aiming_unit:
				aiming_unit.unit_state_machine.use_ability([target])
		Ability.TARGET.SINGLE_ALLY:
			if target.is_in_group("player_unit") and target != aiming_unit:
				aiming_unit.unit_state_machine.use_ability([target])


func handle_selected_enemy(target: Enemy) -> void:
	if not current_ability: return
	if not _within_range(target): return

	if current_ability.target == Ability.TARGET.SINGLE_ENEMY:
		if target.is_in_group("enemy_unit"):
			aiming_unit.unit_state_machine.use_ability([target])


func _within_range(target: Node) -> bool:
	var aiming_tile := arena.get_tile_from_global(aiming_unit.global_position)
	var target_tile := arena.get_hovered_tile()
	
	var delta: Vector2i = (target_tile - aiming_tile).abs()
	var distance := int(delta.x + delta.y)
	
	return distance <= current_ability.max_range
