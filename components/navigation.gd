extends Node
class_name Navigation

var astar_grid: AStarGrid2D


func init(region: Rect2i) -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = region
	astar_grid.cell_size = Battle.CELL_SIZE
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()


func create_id_path(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	# I don't think I care about the initial tile in the path
	return astar_grid.get_id_path(start, end)
