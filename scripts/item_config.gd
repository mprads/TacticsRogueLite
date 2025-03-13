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
	#potions
	RED_POTION,
	YELLOW_POTION,
	GREEN_POTION,
}

const BREWABLE_ITEM_KEYS: Array[KEYS] = [
	KEYS.RED_POTION,
	KEYS.YELLOW_POTION,
	KEYS.GREEN_POTION,
]

const ITEM_RESOURCE_PATHS := {
	#plants
	KEYS.GREEN_HERB: "res://resources/items/green_herb.tres",
	KEYS.RED_MUSHROOM: "res://resources/items/red_mushroom.tres",
	#components
	KEYS.VENOM: "res://resources/items/venom.tres",
	KEYS.ZINC: "res://resources/items/zinc.tres",
	KEYS.SULFUR: "res://resources/items/sulfur.tres",
	#potions
	KEYS.RED_POTION: "res://resources/potions/red_potion.tres",
	KEYS.YELLOW_POTION: "res://resources/potions/green_potion.tres",
	KEYS.GREEN_POTION: "res://resources/potions/green_potion.tres",
}

const BREWING_RECIPE_RESOURCE_PATH := {
	KEYS.RED_POTION: "res://resources/brewing_recipe/red_potion_recipe.tres",
	KEYS.GREEN_POTION: "res://resources/brewing_recipe/green_potion_recipe.tres",
	KEYS.YELLOW_POTION: "res://resources/brewing_recipe/yellow_potion_recipe.tres",
}


static func get_item_resource(key: KEYS) -> Item:
	return load(ITEM_RESOURCE_PATHS.get(key))


static func get_brewable_recipe(key: KEYS) -> BrewingRecipe:
	return load(BREWING_RECIPE_RESOURCE_PATH.get(key))
