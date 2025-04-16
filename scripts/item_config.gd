extends Object
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
	DEFENCE_POTION,
	OFFENCE_POTION,
	BALANCE_POTION,
	DEBUFF_POTION,
	SUPPORT_POTION,
}

const POTION_KEYS: Array[KEYS] = [
	KEYS.DEFENCE_POTION,
	KEYS.OFFENCE_POTION,
	KEYS.BALANCE_POTION,
	KEYS.DEBUFF_POTION,
	KEYS.SUPPORT_POTION,
]

const ITEM_RESOURCE_PATHS := {
	#plants
	KEYS.GREEN_HERB: "res://resources/items/green_herb.tres",
	KEYS.RED_MUSHROOM: "res://resources/items/red_mushroom.tres",
	#components
	KEYS.VENOM: "res://resources/items/venom.tres",
	KEYS.ZINC: "res://resources/items/zinc.tres",
	KEYS.SULFUR: "res://resources/items/sulfur.tres",
}

const POTION_RESOURCE_PATH := {
	KEYS.DEFENCE_POTION: "res://resources/potions/defence_potion.tres",
	KEYS.OFFENCE_POTION: "res://resources/potions/offence_potion.tres",
	KEYS.BALANCE_POTION: "res://resources/potions/balance_potion.tres",
	KEYS.DEBUFF_POTION: "res://resources/potions/debuff_potion.tres",
	KEYS.SUPPORT_POTION: "res://resources/potions/support_potion.tres",
}

const BREWING_RECIPE_RESOURCE_PATH := {
	KEYS.DEFENCE_POTION: "res://resources/brewing_recipe/defence_potion_recipe.tres",
	KEYS.OFFENCE_POTION: "res://resources/brewing_recipe/offence_potion_recipe.tres",
	KEYS.BALANCE_POTION: "res://resources/brewing_recipe/balance_potion_recipe.tres",
	KEYS.DEBUFF_POTION: "res://resources/brewing_recipe/debuff_potion_recipe.tres",
	KEYS.SUPPORT_POTION: "res://resources/brewing_recipe/support_potion_recipe.tres",
}


static func get_item_resource(key: KEYS) -> Item:
	return load(ITEM_RESOURCE_PATHS[key])


static func get_potion_resource(key: KEYS) -> Potion:
	return load(POTION_RESOURCE_PATH[key])


static func get_brewing_recipe(key: KEYS) -> BrewingRecipe:
	return load(BREWING_RECIPE_RESOURCE_PATH[key])
