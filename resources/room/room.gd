class_name Room
extends Resource

enum TYPE { NOT_ASSIGNED, BATTLE, KILN, BREWING, SHOP, ELITE, BOSS, REST, EVENT }

@export var type: TYPE
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected := false
@export var battle_stats: BattleStats
