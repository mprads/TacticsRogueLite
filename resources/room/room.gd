extends Resource
class_name Room

enum Type {NOT_ASSIGNED, KILN, BREWING, SHOP, BATTLE}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected := false
