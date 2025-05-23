extends Resource
class_name Room

enum TYPE { NOT_ASSIGNED, BATTLE, KILN, BREWING, SHOP, ELITE }

@export var type: TYPE
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected := false
@export var battle_stats: BattleStats
