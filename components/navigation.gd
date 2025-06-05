extends Node
class_name Navigation

var astar_grid: AStarGrid2D


func init(region: Rect2i, tiles: Array[Vector2i]) -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = region
	astar_grid.cell_size = Battle.CELL_SIZE
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.set_cell_shape(AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN)
	astar_grid.update()

	astar_grid.fill_solid_region(region, true)
	for tile in tiles:
		astar_grid.set_point_solid(tile, false)

	astar_grid.update()


func create_id_path(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	return astar_grid.get_id_path(start, end)


func set_id_occupied(id: Vector2i) -> void:
	astar_grid.set_point_solid(id, true)
	astar_grid.update()


func set_id_empty(id: Vector2i) -> void:
	astar_grid.set_point_solid(id, false)
	astar_grid.update()
