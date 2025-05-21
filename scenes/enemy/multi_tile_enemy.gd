extends Enemy
class_name MultiTileEnemy


func take_turn() -> void:
	request_enemy_move.emit(ai.next_tile)


func move_cleanup() -> void:
	use_ability()


func use_ability() -> void:
	# ai is not going to have targets because its a swipe
	stats.ability.apply_effects([ai.current_target], modifier_manager)
	await get_tree().create_timer(.5).timeout
	turn_completed.emit()


# targets are going to be tiles and not units
func _on_mouse_entered() -> void:
	sprite_2d.material.set_shader_parameter('outline_thickness', outline_thickness)
	selectable = true
	# Clunky but when two enemies are next to each other the area2ds overlap
	# and mouse entered signal seems to have priority over exit signal
	# so create a lambda and delay till end of frame
	(func():
		request_flood_fill.emit(stats.movement, Vector2i(2, 0))

		if ai.current_target:
			show_intent.emit(self)
		).call_deferred()
