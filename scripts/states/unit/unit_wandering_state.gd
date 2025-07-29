class_name UnitWanderingState
extends UnitState

var wander_timer: SceneTreeTimer 
var x_dir := 0.0
var y_dir := 0.0


func enter() -> void:
	unit.drag_and_drop.enabled = false
	unit.moveable = false
	unit.selectable = false
	wander_timer = unit.get_tree().create_timer(randf_range(0.5, 1.5))
	wander_timer.timeout.connect(_on_wander_timer_timeout)


func exit() -> void:
	wander_timer.timeout.disconnect(_on_wander_timer_timeout)
	wander_timer.queue_free()
	wander_timer = null


func on_physics_process(delta: float) -> void:
	unit.position.x += x_dir
	unit.position.y += y_dir


func _on_wander_timer_timeout() -> void:
	x_dir = randf_range(0.0, 0.5)
	y_dir = randf_range(0.0, 0.5)
