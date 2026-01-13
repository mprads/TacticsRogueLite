class_name Battle
extends Node2D

const CELL_SIZE := Vector2(32, 32)
const HALF_CELL_SIZE := Vector2(16, 16)

@export var map: BattleMap
@export var battle_stats: BattleStats
@export var battle_manager: BattleManager
@export var party_manager: PartyManager

@export var battle_map_pool: BattleMapPool


func start_battle() -> void:
	battle_manager.battle_stats = battle_stats
	battle_manager.party_manager = party_manager
	if battle_stats.get("unique_map"):
		battle_manager.map = battle_stats.unique_map
	else:
		battle_manager.map = battle_map_pool.get_map()
	_generate_map()
	battle_manager.start_deployment()

	MusicPlayer.play(SFXConfig.get_audio_stream(SFXConfig.KEYS.BATTLE_MUSIC), true)


func _generate_map() -> void:
	if not map and not battle_manager:
		return

	battle_manager.generate_arena()
