extends Resource
class_name BattleMap

# TODO this is miserable to do more than once, make tool to create from scene
@export var tiles: Array[Vector2i]
@export var tileset: TileSet
