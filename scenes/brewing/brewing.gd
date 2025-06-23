class_name Brewing
extends Node2D

enum STAGE { RECIPE, SELECTION, POTION, VIAL }

const RECIPE_PANEL = preload("res://scenes/ui/recipe_panel.tscn")
const ITEM_PANEL = preload("res://scenes/ui/item_panel.tscn")
const VIAL_PANEL = preload("res://scenes/ui/vial_panel.tscn")

@export var inventory_manager: InventoryManager : set = set_inventory_manager
@export var party_manager: PartyManager : set = set_party_manager
@export var vial_manager: VialManager : set = set_vial_manager

@onready var recipe_scroll_container: ScrollContainer = %RecipeScrollContainer
@onready var recipe_container: VBoxContainer = %RecipeContainer
@onready var party_ui: PartyUI = %PartyUI
@onready var vial_container: VBoxContainer = %VialContainer

@onready var selection_buttons: VBoxContainer = %SelectionButtons
@onready var potion_button: Button = %PotionButton
@onready var vial_button: Button = %VialButton
@onready var leave_button: Button = %LeaveButton
@onready var no_recipes_panel: Panel = %NoRecipesPanel

@onready var open_book: TextureRect = %OpenBook
@onready var closed_book: TextureRect = %ClosedBook


var all_recipes_keys: Array[int] = []
var filtered_recipes_keys: Array[int] =[]
var current_stage := STAGE.RECIPE
var current_potion: Potion
var current_recipe: BrewingRecipe


func _ready() -> void:
	party_ui.unit_selected.connect(_on_party_unit_selected)
	potion_button.pressed.connect(_on_potion_button_pressed)
	vial_button.pressed.connect(_on_vial_button_pressed)
	leave_button.pressed.connect(Events.brewing_exited.emit)

	for recipe in ItemConfig.POTION_KEYS:
		all_recipes_keys.append(recipe)

	_update_view(STAGE.RECIPE)


func _update_view(next_stage: STAGE) -> void:
	match next_stage:
		STAGE.RECIPE:
			recipe_scroll_container.show()
			party_ui.hide()
			vial_container.hide()
			selection_buttons.hide()
			leave_button.show()
			current_potion = null
			current_recipe = null

		STAGE.SELECTION:
			recipe_scroll_container.show()
			party_ui.hide()
			vial_container.hide()
			selection_buttons.show()

		STAGE.POTION:
			recipe_scroll_container.show()
			party_ui.show()
			vial_container.hide()
			selection_buttons.hide()

		STAGE.VIAL:
			recipe_scroll_container.show()
			party_ui.hide()
			vial_container.show()
			selection_buttons.hide()

	current_stage = next_stage


func _filter_recipes() -> void:
	var inventory = inventory_manager.get_inventory()

	filtered_recipes_keys = all_recipes_keys.filter(func(recipe_key):
		var recipe = ItemConfig.get_brewing_recipe(recipe_key)

		for cost in recipe.costs:
			if inventory.has(cost.item_key):
				if inventory[cost.item_key] < clampi(cost.amount / 2, 1, cost.amount):
					return false
			else: 
				return false

		return true
		)


func _update_recipes() -> void:
	for child in recipe_container.get_children():
		child.queue_free()

	for key in filtered_recipes_keys:
		var recipe_panel_instance := RECIPE_PANEL.instantiate()
		recipe_container.add_child(recipe_panel_instance)
		recipe_panel_instance.potion_key = key
		recipe_panel_instance.pressed.connect(
			_on_recipe_panel_pressed.bind(recipe_panel_instance.potion, recipe_panel_instance.recipe)
		)

	_handle_no_recipes()


func _handle_no_recipes() -> void:
	if filtered_recipes_keys.is_empty():
		no_recipes_panel.show()
		closed_book.show()
		open_book.hide()
	else:
		no_recipes_panel.hide()


func _update_buttons(potion: Potion, recipe: BrewingRecipe) -> void:
	var inventory = inventory_manager.get_inventory()

	potion_button.text = "Brew %s Potion" %potion.name
	vial_button.text = "Brew %s Vial" %potion.name
	potion_button.disabled = false

	for cost in recipe.costs:
		if inventory[cost.item_key] < cost.amount:
			potion_button.disabled = true


func _update_vials() -> void:
	for child in vial_container.get_children():
		child.queue_free()

	for vial in vial_manager.get_vials():
		var vial_panel_instance := VIAL_PANEL.instantiate()
		vial_container.add_child(vial_panel_instance)
		vial_panel_instance.potion = vial.potion
		vial_panel_instance.pressed.connect(_on_vial_panel_pressed.bind(vial))


func _request_remove_components() -> void:
	pass
	#for component in component_container.get_children():
		#Events.request_remove_item.emit(component.item, component.count)


func _update_component_cost(is_vial: bool) -> void:
	pass
	#for component in component_container.get_children():
		#var cost_index = current_recipe.costs.find_custom(func(item): return item.item_key == component.item.key)
		#var cost = current_recipe.costs[cost_index]
#
		#if is_vial:
			#component.count = clampi(cost.amount / 2, 1, cost.amount)
		#else:
			#component.count = cost.amount


func set_inventory_manager(value: InventoryManager) -> void:
	if not is_node_ready():
		await ready

	inventory_manager = value
	_filter_recipes()
	_update_recipes()


func set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value
	# TODO Ew prop drilling
	party_ui.party_manager = party_manager


func set_vial_manager(value: VialManager) -> void:
	if not is_node_ready():
		await ready

	vial_manager = value
	vial_manager.vials_changed.connect(_update_vials)
	_update_vials()


func _on_recipe_panel_pressed(potion: Potion, recipe: BrewingRecipe) -> void:
	current_potion = potion
	current_recipe = recipe

	_update_buttons(potion, recipe)

	_update_view(STAGE.SELECTION)


func _on_potion_button_pressed() -> void:
	_update_component_cost(false)
	_update_view(STAGE.POTION)


func _on_vial_button_pressed() -> void:
	_update_component_cost(true)
	_update_view(STAGE.VIAL)


func _on_party_unit_selected(unit: UnitStats) -> void:
	unit.potion = current_potion
	_request_remove_components()
	Events.brewing_exited.emit()


func _on_vial_panel_pressed(vial: Vial) -> void:
	vial.potion = current_potion
	_request_remove_components()
	Events.brewing_exited.emit()
