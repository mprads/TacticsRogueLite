extends Node2D
class_name Battle

const TESTING_6X_6 = preload("res://resources/battle_maps/testing_6x6.tres")

const CELL_SIZE := Vector2(64, 64)
const HALF_CELL_SIZE := Vector2(32, 32)

@export var map: BattleMap
@export var battle_manager: BattleManager
@export var party_manager: PartyManager


@onready var button: Button = $UI/VBoxContainer/Button


func _ready() -> void:
	button.pressed.connect(Events.battle_won.emit)
	map = TESTING_6X_6


func generate_map() -> void:	
	if not map and not battle_manager:
		return
	
	battle_manager.map = map
	battle_manager.party_manager = party_manager
	battle_manager.generate_map()
