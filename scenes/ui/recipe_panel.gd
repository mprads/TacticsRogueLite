class_name RecipePanel
extends Button

const RECIPE_PANEL_SCENE = preload("uid://bco8m3hvgdeh4")

@export var potion_key: int:
	set = set_potion_key
@export var potion: Potion
@export var recipe: BrewingRecipe

@onready var potion_label: Label = %PotionLabel
@onready var component_container: HBoxContainer = %ComponentContainer
@onready var ability_container: VBoxContainer = %AbilityContainer


func _update_visuals() -> void:
	for child in ability_container.get_children():
		child.queue_free()

	if not potion or not recipe:
		return

	potion_label.text = potion.name
	potion_label.modulate = potion.color

	for ability in potion.abilities:
		var ability_panel_instance := AbilityPanel.create_new(ability)
		ability_container.add_child(ability_panel_instance)

	_update_components()


func _update_components() -> void:
	for child in component_container.get_children():
		child.queue_free()

	for cost in recipe.costs:
		var item_panel_instance := ItemPanel.create_new(ItemConfig.get_item_resource(cost.item_key), cost.amount)
		component_container.add_child(item_panel_instance)


func set_potion_key(value: int) -> void:
	if not is_node_ready(): await ready

	potion_key = value

	potion = ItemConfig.get_potion_resource(potion_key)
	recipe = ItemConfig.get_brewing_recipe(potion_key)
	_update_visuals()


static func create_new(key: ItemConfig.KEYS) -> RecipePanel:
	var new_recipe_panel := RECIPE_PANEL_SCENE.instantiate()
	new_recipe_panel.potion_key = key
	return new_recipe_panel
