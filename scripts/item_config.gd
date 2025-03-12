extends Node
class_name ItemConfig

enum KEYS {
	#plants
	GREEN_HERB,
	RED_MUSHROOM,
	#components
	VENOM,
	ZINC,
	SULFUR,
	
}

const ITEM_RESOURCE_PATHS := {
	#plants
	KEYS.GREEN_HERB: "res://resources/items/green_herb.tres",
	KEYS.RED_MUSHROOM: "res://resources/items/red_mushroom.tres",
	#components
	KEYS.VENOM: "res://resources/items/venom.tres",
	KEYS.ZINC: "res://resources/items/zinc.tres",
	KEYS.SULFUR: "res://resources/items/sulfur.tres",
}


static func get_item_resource(key: KEYS) -> Item:
	return load(ITEM_RESOURCE_PATHS.get(key))
