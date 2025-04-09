extends Node2D
class_name AbilityManager

var aiming_unit: Unit
var current_ability: Ability


func has_active_ability() -> bool:
	return current_ability != null


func handle_unit_aim(unit: Unit, ability: Ability) -> void:
	aiming_unit = unit
	current_ability = ability


func handle_aim_stopped() -> void:
	aiming_unit = null
	current_ability = null


func handle_selected_unit(target: Unit) -> void:
	if not current_ability: return

	match current_ability.target:
		Ability.TARGET.SELF:
			if target == aiming_unit:
				aiming_unit.unit_state_machine.use_ability([target])
		Ability.TARGET.SINGLE_ALLY:
			if target.is_in_group("player_unit") and target != aiming_unit:
				aiming_unit.unit_state_machine.use_ability([target])


func handle_selected_enemy(target: Enemy) -> void:
	if not current_ability: return
	
	if current_ability.target == Ability.TARGET.SINGLE_ENEMY:
		if target.is_in_group("enemy_unit"):
			aiming_unit.unit_state_machine.use_ability([target])
