class_name UnitWanderingState
extends UnitState

const TOP_NAV_OFFSET := 28

var wander_timer: Timer 
var x_dir := 0.0
var y_dir := 0.0
var x_screen_max := 0
var x_screen_min := 0
var y_screen_max := 0
var y_screen_min := 0


func enter() -> void:
	unit.drag_and_drop.enabled = false
	unit.moveable = false
	unit.selectable = false
	var viewport_size = unit.get_viewport_rect().size
	x_screen_max = viewport_size.x - unit.collision_shape_2d.shape.size.x
	x_screen_min = 0 + unit.collision_shape_2d.shape.size.x
	y_screen_max = viewport_size.y - unit.collision_shape_2d.shape.size.y
	y_screen_min = 0 + unit.collision_shape_2d.shape.size.y + TOP_NAV_OFFSET

	wander_timer = Timer.new()
	unit.add_child(wander_timer)
	wander_timer.wait_time = randf_range(0.5, 1.5)
	wander_timer.one_shot = false
	wander_timer.start()
	wander_timer.timeout.connect(_on_wander_timer_timeout)


func exit() -> void:
	wander_timer.timeout.disconnect(_on_wander_timer_timeout)
	wander_timer.queue_free()
	wander_timer = null


func on_physics_process(_delta: float) -> void:
	if unit.position.x >= x_screen_max or unit.position.y >= y_screen_max:
		x_dir *= -1
		y_dir *= -1
	elif unit.position.x <= x_screen_min or unit.position.y <= y_screen_min:
		x_dir *= -1
		y_dir *= -1

	unit.position.x += x_dir
	unit.position.y += y_dir


func _on_wander_timer_timeout() -> void:
	x_dir = randf_range(-0.5, 0.5)
	y_dir = randf_range(-0.5, 0.5)
