extends Node2D
class_name Brewing

const RECIPE_PANEL = preload("res://scenes/ui/recipe_panel.tscn")
const ITEM_PANEL = preload("res://scenes/ui/item_panel.tscn")

@export var inventory_manager: InventoryManager : set = _set_inventory_manager

@onready var cauldron_contents: TextureRect = %CauldronContents
@onready var recipe_container: VBoxContainer = %RecipeContainer
@onready var component_container: HBoxContainer = %ComponentContainer

var all_recipes_keys: Array[int] = []


func _ready() -> void:
	for recipe in ItemConfig.POTION_KEYS:
		all_recipes_keys.append(recipe)


func _update_recipes() -> void:
	for child in recipe_container.get_children():
		child.queue_free()

	for key in all_recipes_keys:
		var recipe_panel_instance := RECIPE_PANEL.instantiate()
		recipe_container.add_child(recipe_panel_instance)
		recipe_panel_instance.potion_key = key
		recipe_panel_instance.pressed.connect(
			_on_recipe_panel_pressed.bind(recipe_panel_instance.potion, recipe_panel_instance.recipe)
		)


func _update_cauldron(potion: Potion, recipe: BrewingRecipe) -> void:	
	for child in component_container.get_children():
		child.queue_free()
	
	for cost in recipe.costs:
		var item_panel_instance := ITEM_PANEL.instantiate()
		component_container.add_child(item_panel_instance)
		item_panel_instance.item = ItemConfig.get_item_resource(cost.item_key)
		item_panel_instance.count = cost.amount
	
	cauldron_contents.modulate = potion.color


func _set_inventory_manager(value: InventoryManager) -> void:
	if not is_node_ready():
		await ready
	
	inventory_manager = value
	_update_recipes()


func _on_recipe_panel_pressed(potion: Potion, recipe: BrewingRecipe) -> void:
	_update_cauldron(potion, recipe)
