extends Enemy
class_name MultiTileEnemy


func take_turn() -> void:
	request_enemy_move.emit(ai.next_tile)


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
