extends Button

const ITEM_PANEL = preload("res://scenes/ui/item_panel.tscn")

@export var potion_key: int : set = _potion_key
@export var potion: Potion
@export var recipe: BrewingRecipe

@onready var potion_label: Label = %PotionLabel
@onready var component_container: HBoxContainer = %ComponentContainer
@onready var attack_container: HBoxContainer = %AttackContainer
@onready var ability_label_1: Label = %AbilityLabel1
@onready var ability_label_2: Label = %AbilityLabel2

@onready var header: Panel = %Header
@onready var border: Panel = %Border
@onready var header_sb: StyleBoxFlat = header.get_theme_stylebox("panel")
@onready var border_sb: StyleBoxFlat = border.get_theme_stylebox("panel")


func _update_visuals() -> void:
	if not potion or not recipe: return
	
	potion_label.text = potion.name
	header_sb.bg_color = potion.color
	border_sb.border_color = potion.color
	
	#TODO Create a proper reusbale attack panel with tool tips
	printt(potion.abilities[0].name,potion.abilities[1].name)
	ability_label_1.text = potion.abilities[0].name
	ability_label_2.text = potion.abilities[1].name
	
	_update_components()
	

func _update_components() -> void:
	for child in component_container.get_children():
		child.queue_free()

	for cost in recipe.costs:
		var item_panel_instance := ITEM_PANEL.instantiate()
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
