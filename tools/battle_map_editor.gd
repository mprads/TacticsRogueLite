@tool
class_name BattleMapEditor
extends Node2D

const PATH := "res://resources/battle_maps/"

@export_tool_button("save_map") var button = save_map

@export var test_arena: Arena
@export var file_name: Label


func save_map() -> void:
	var battle_map := BattleMap.new()
	battle_map.tile_set = test_arena.tile_set

	var used_cells := test_arena.get_used_cells()

	for coord in used_cells:
		var data := test_arena.get_cell_tile_data(coord)
		var atlas_coord := test_arena.get_cell_atlas_coords(coord)
		var source_id := test_arena.get_cell_source_id(coord)
		(
			battle_map
			. tiles
			. append(
				{
					"coord": coord,
					"atlas_coord": atlas_coord,
					"source_id": source_id,
				}
			)
		)

	var file_path := PATH + file_name.text + ".tres"
	ResourceSaver.save(battle_map, file_path)
