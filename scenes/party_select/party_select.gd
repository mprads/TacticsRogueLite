extends Control
class_name PartySelect

const RUN_SCENE = preload("res://scenes/run/run.tscn")
const UNIT_SELECT_PANEL_SCENE = preload("res://scenes/party_select/unit_select_panel.tscn")
const UNIT_ICON_PANEL_SCENE = preload("res://scenes/ui/unit_icon_panel.tscn")
const ITEM_PANEL_SCENE = preload("res://scenes/ui/item_panel.tscn")
const VIAL_BUTTON_SCENE = preload("res://scenes/ui/vial_button.tscn")
const OPTION_COUNT := 3

@export_category("Pools")
@export var starter_bottles: Array[Bottle]
@export var starter_potions: Array[Potion]
@export var starter_items: Array[Item]
@export var starter_artifacts: Array[Artifact]

@export_category("Ranges")
@export var vial_odds: float
@export var gold_odds: float
@export var gold_min: int
@export var gold_max: int
@export var item_quantity_min: int
@export var item_quantity_max: int

@export var run_stats: RunStats
@onready var inventory_manager: InventoryManager = $InventoryManager
@onready var party_manager: PartyManager = $PartyManager
@onready var vial_manager: VialManager = $VialManager
@onready var artifact_manager: ArtifactManager = $ArtifactManager

@onready var selection_container: HBoxContainer = %SelectionContainer
@onready var party_container: HBoxContainer = %PartyContainer
@onready var vial_container: HBoxContainer = %VialContainer
@onready var inventory_container: HBoxContainer = %InventoryContainer
@onready var gold_ui: GoldUI = %GoldUI
@onready var unit_creator_ui: PanelContainer = %UnitCreatorUI


func _ready() -> void:
	if not run_stats:
		run_stats = RunStats.new()
		_set_up_managers()

	_set_up_connections()
	_generate_options()


func _set_up_managers() -> void:
	inventory_manager.run_stats = run_stats
	party_manager.run_stats = run_stats
	vial_manager.run_stats = run_stats
	artifact_manager.run_stats = run_stats

	gold_ui.inventory_manager = inventory_manager


func _set_up_connections() -> void:
	inventory_manager.inventory_changed.connect(_on_inventory_changed)
	party_manager.party_changed.connect(_on_party_changed)
	vial_manager.vials_changed.connect(_on_vials_changed)
	unit_creator_ui.unit_created.connect(_on_unit_created)


func _generate_options(final: bool = false) -> void:
	for child in selection_container.get_children():
		child.queue_free()

	for option in OPTION_COUNT:
		var unit_select_instance := UNIT_SELECT_PANEL_SCENE.instantiate()
		selection_container.add_child(unit_select_instance)
		var unit_stats := _generate_unit_stats()
		unit_select_instance.unit_stats = unit_stats
		unit_select_instance.panel_selected.connect(_on_panel_selected)

		if final:
			unit_select_instance.contents = _generate_artifact()
		else:
			unit_select_instance.contents = _generate_items()


func _generate_unit_stats() -> UnitStats:
	var unit_stats := UnitStats.new()
	var bottle: Bottle = RNG.array_pick_random(starter_bottles)
	var potion: Potion = RNG.array_pick_random(starter_potions)
	unit_stats.bottle = bottle
	unit_stats.potion = potion

	return unit_stats


func _generate_items() -> Array:
	var item_contents := []

	for item in OPTION_COUNT:
			var chance := randf_range(0.0, 1.0)

			# TODO Maybe this should be a weighted table for more granular control
			if chance <= vial_odds:
				var vial := Vial.new()
				var potion: Potion = RNG.array_pick_random(starter_potions)
				vial.potion = potion
				item_contents.append({ "item": vial, "quantity": 1 })
			elif chance <= gold_odds:
				var gold_value := RNG.instance.randi_range(gold_min, gold_max)
				item_contents.append({ "item": "gold", "quantity": gold_value })
			else:
				var starter_item: Item = RNG.array_pick_random(starter_items)
				var quantity := RNG.instance.randi_range(item_quantity_min, item_quantity_max)
				item_contents.append({ "item": starter_item, "quantity": quantity })

	return item_contents


func _generate_artifact() -> Array[Dictionary]:
	var starter_artifact = RNG.array_pick_random(starter_artifacts)
	return [{ "item": starter_artifact, "quantity": 1 }]


func _show_unit_creator(unit_stats: UnitStats) -> void:
	for child in selection_container.get_children():
		child.play_discard()

	unit_creator_ui.unit_stats = unit_stats
	unit_creator_ui.visible = true


func _fill_placeholders(container: HBoxContainer) -> void:
	for empty_slot in (OPTION_COUNT - container.get_child_count()):
		var panel_instance = Panel.new()
		container.add_child(panel_instance)
		panel_instance.custom_minimum_size = Vector2(48, 48)


func _on_panel_selected(unit_stats: UnitStats, contents: Array) -> void:
	for content in contents:
		if content.item is Item:
			inventory_manager.add_item(content.item, content.quantity)
		elif content.item is Vial:
			vial_manager.add_vial(content.item)
		elif content.item is Artifact:
			artifact_manager.add_artifact(content.item)
		else:
			inventory_manager.add_gold(content.quantity)

	_show_unit_creator(unit_stats)


func _on_inventory_changed() -> void:
	for child in inventory_container.get_children():
		child.queue_free()

	var inventory := inventory_manager.get_inventory()

	for item in inventory:
		var item_panel_instance := ITEM_PANEL_SCENE.instantiate()
		inventory_container.add_child(item_panel_instance)
		item_panel_instance.item = ItemConfig.get_item_resource(item)
		item_panel_instance.count = inventory[item]


func _on_party_changed() -> void:
	for child in party_container.get_children():
		child.queue_free()
		party_container.remove_child(child)

	var party := party_manager.get_party()

	for unit_stats in party:
		var unit_panel_instance := UNIT_ICON_PANEL_SCENE.instantiate()
		party_container.add_child(unit_panel_instance)
		unit_panel_instance.unit = unit_stats

	_fill_placeholders(party_container)


func _on_vials_changed() -> void:
	for child in vial_container.get_children():
		child.queue_free()
		vial_container.remove_child(child)

	var vials := vial_manager.get_vials()

	for vial in vials:
		var vial_button_instance := VIAL_BUTTON_SCENE.instantiate()
		var panel_instance := Panel.new()
		vial_container.add_child(panel_instance)
		panel_instance.custom_minimum_size = Vector2(48, 48)
		panel_instance.add_child(vial_button_instance)
		vial_button_instance.position = Vector2(12, 12)
		vial_button_instance.vial = vial

	_fill_placeholders(vial_container)


func _on_unit_created(unit_stats: UnitStats) -> void:
	unit_creator_ui.visible = false
	party_manager.add_unit(unit_stats)

	if party_manager.get_party().size() >= 3:
		SceneChanger.change_scene(RUN_SCENE, run_stats)
	elif party_manager.get_party().size() >= 2:
		_generate_options(true)
	else:
		_generate_options()
