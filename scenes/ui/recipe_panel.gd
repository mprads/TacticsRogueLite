class_name RecipePanel
extends Button

const ITEM_PANEL_SCENE = preload("res://scenes/ui/item_panel.tscn")
const ABILITY_PANEL_SCENE = preload("res://scenes/ui/ability_panel.tscn")

@export var potion_key: int:
	set = _potion_key
@export var potion: Potion
@export var recipe: BrewingRecipe

@onready var potion_label: Label = %PotionLabel
@onready var component_container: HBoxContainer = %ComponentContainer
@onready var ability_containter: HBoxContainer = %AbilityContainter

@onready var header: Panel = %Header
@onready var border: Panel = %Border
@onready var header_sb: StyleBoxFlat = header.get_theme_stylebox("panel")
@onready var border_sb: StyleBoxFlat = border.get_theme_stylebox("panel")


func _update_visuals() -> void:
	for child in ability_containter.get_children():
		child.queue_free()

	if not potion or not recipe:
		return

	potion_label.text = potion.name
	header_sb.bg_color = potion.color
	border_sb.border_color = potion.color

	for ability in potion.abilities:
		var ability_panel_instance := ABILITY_PANEL_SCENE.instantiate()
		ability_containter.add_child(ability_panel_instance)
		ability_panel_instance.ability = ability

	_update_components()


func _update_components() -> void:
	for child in component_container.get_children():
		child.queue_free()

	for cost in recipe.costs:
		var item_panel_instance := ITEM_PANEL_SCENE.instantiate()
		component_container.add_child(item_panel_instance)
		item_panel_instance.item = ItemConfig.get_item_resource(cost.item_key)
		item_panel_instance.count = cost.amount


func _potion_key(value: int) -> void:
	if not is_node_ready():
		await ready

	potion_key = value

	potion = ItemConfig.get_potion_resource(potion_key)
	recipe = ItemConfig.get_brewing_recipe(potion_key)
	_update_visuals()
