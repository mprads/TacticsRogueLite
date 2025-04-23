extends Node2D
class_name TargetSelectorUI

const ARC_POINTS := 8

@onready var mouse_point: Node2D = $MousePoint
@onready var line_2d: Line2D = $CanvasLayer/Line2D

var enabled := false
var starting_position: Vector2 : set  = set_starting_position
var ending_position: Vector2 : set = set_ending_position

func _process(_delta: float) -> void:
	if not enabled: return

	mouse_point.position = get_local_mouse_position()
	line_2d.points = _get_points(mouse_point.position)


func _get_points(target: Vector2) -> Array:
	var points := []

	var distance := (target - starting_position)

	for i in ARC_POINTS:
		var t := (1.0 / ARC_POINTS) * i
		var x := starting_position.x + (distance.x / ARC_POINTS) * i
		var y := starting_position.y + _ease_out_cubic(t) * distance.y
		points.append(Vector2(x, y))

	points.append(target)

	return points


func _ease_out_cubic(number : float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)


func set_starting_position(value: Vector2) -> void:
	starting_position = value
	line_2d.clear_points()
	mouse_point.position = Vector2.ZERO


func set_ending_position(value: Vector2) -> void:
	ending_position = value
	mouse_point.position = ending_position
	line_2d.points = _get_points(mouse_point.position)
