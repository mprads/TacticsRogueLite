extends Node
class_name Run

const BATTLE_SCENE := preload("res://scenes/battle/battle.tscn")
const BATTLE_REWARD_SCENE = preload("res://scenes/battle_reward/battle_reward.tscn")
const BATTLE_LOST_SCENE = preload("res://scenes/battle_lost/battle_lost.tscn")
const SHOP_SCENE := preload("res://scenes/shop/shop.tscn")
const BREWING_SCENE := preload("res://scenes/brewing/brewing.tscn")
const KILN_SCNE := preload("res://scenes/kiln/kiln.tscn")

@export var run_stats: RunStats
@onready var inventory_manager: InventoryManager = $InventoryManager
@onready var party_manager: PartyManager = $PartyManager
@onready var vial_manager: VialManager = $VialManager
@onready var artifact_manager: ArtifactManager = $ArtifactManager

@onready var artifact_ui: HBoxContainer = %ArtifactUI
@onready var vial_ui: VialUI = %VialUI
@onready var gold_ui: HBoxContainer = %GoldUI
@onready var inventory_button: TextureButton = %InventoryButton
@onready var settings_button: TextureButton = %SettingsButton
@onready var settings_ui: Control = %SettingsUI

@onready var current_view: Node = $CurrentView
@onready var map: Node2D = $Map
@onready var inventory_ui: InventoryUI = $TopBar/InventoryUI

# temp debug shorcuts
@onready var debug: PanelContainer = $TopBar/Debug
@onready var map_button: Button = %MapButton
@onready var kiln_button: Button = %KilnButton
@onready var brewing_button: Button = %BrewingButton
@onready var shop_button: Button = %ShopButton



func _ready() -> void:
	if not run_stats:
		run_stats = RunStats.new()
		_start_run()
	else:
		#TODO add loading a run from save state
		_start_run()


func _start_run() -> void:	
	_set_up_managers()
	_set_up_top_bar()
	_set_up_event_connections()

	_set_up_debug()

	map.generate_new_map()
	map.unlock_row(0)


func _set_up_debug() -> void:
	settings_button.pressed.connect(func():
		settings_ui.visible = !settings_ui.visible
		debug.visible = !debug.visible
	)
	map_button.pressed.connect(func():
		settings_ui.visible = !settings_ui.visible
		debug.visible = !debug.visible
		_show_map()
	)
	kiln_button.pressed.connect(func():
		settings_ui.visible = !settings_ui.visible
		debug.visible = !debug.visible
		_on_kiln_entered()
	)
	brewing_button.pressed.connect(func():
		settings_ui.visible = !settings_ui.visible
		debug.visible = !debug.visible
		_on_brewing_entered()
	)
	shop_button.pressed.connect(func():
		settings_ui.visible = !settings_ui.visible
		debug.visible = !debug.visible
		_on_shop_entered()
	)


func _set_up_managers() -> void:
	inventory_manager.run_stats = run_stats
	party_manager.run_stats = run_stats
	vial_manager.run_stats = run_stats
	artifact_manager.run_stats = run_stats
	artifact_manager.artifact_ui = artifact_ui


func _set_up_event_connections() -> void:
	Events.battle_exited.connect(_show_map)
	Events.battle_won.connect(_on_battle_won)
	Events.battle_lost.connect(_on_battle_lost)
	Events.retry_battle.connect(_on_retry_battle)
	Events.battle_reward_exited.connect(_show_map)
	Events.shop_exited.connect(_show_map)
	Events.brewing_exited.connect(_show_map)
	Events.kiln_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)


func _set_up_top_bar() -> void:
	inventory_button.pressed.connect(inventory_ui.toggle_view)

	artifact_manager.init_artifacts()
	vial_ui.vial_manager = vial_manager
	gold_ui.inventory_manager = inventory_manager
	inventory_ui.inventory_manager = inventory_manager
	inventory_ui.party_manager = party_manager


func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()

	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	map.hide_map()
	
	return new_view


func _show_map() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()

	map.show_map()
	map.unlock_next_rooms()


func _show_battle_reward() -> void:
	var reward_scene := _change_view(BATTLE_REWARD_SCENE)
	reward_scene.battle_stats = map.last_room.battle_stats


func _show_battle_lost() -> void:
	var lost_scene := _change_view(BATTLE_LOST_SCENE)
	lost_scene.party_manager = party_manager


func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.TYPE.BATTLE:
			_on_battle_entered(room)
		Room.TYPE.ELITE:
			_on_battle_entered(room)
		Room.TYPE.SHOP:
			_on_shop_entered()
		Room.TYPE.BREWING:
			_on_brewing_entered()
		Room.TYPE.KILN:
			_on_kiln_entered()


func _on_battle_entered(room: Room) -> void:
	var battle := _change_view(BATTLE_SCENE)
	battle.battle_stats = room.battle_stats
	battle.party_manager = party_manager
	battle.start_battle()


func _on_battle_won() -> void:
	_show_battle_reward()


func _on_battle_lost() -> void:
	_show_battle_lost()


func _on_retry_battle() -> void:
	_on_battle_entered(map.last_room)


func _on_shop_entered() -> void:
	var shop := _change_view(SHOP_SCENE)
	shop.inventory_manager = inventory_manager
	shop.artifact_manager = artifact_manager
	shop.populate_shop()
	Events.shop_entered.emit(shop)


func _on_brewing_entered() -> void:
	var brewing := _change_view(BREWING_SCENE)
	brewing.inventory_manager = inventory_manager
	brewing.party_manager = party_manager
	brewing.vial_manager = vial_manager
	Events.brewing_entered.emit(brewing)


func _on_kiln_entered() -> void:
	var kiln := _change_view(KILN_SCNE)
	kiln.party_manager = party_manager
