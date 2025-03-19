extends Node
class_name Run

const BATTLE_SCENE := preload("res://scenes/battle/battle.tscn")
const SHOP_SCENE := preload("res://scenes/shop/shop.tscn")
const BREWING_SCENE := preload("res://scenes/brewing/brewing.tscn")
const KILN_SCNE := preload("res://scenes/kiln/kiln.tscn")

@export var run_stats: RunStats
@onready var inventory_manager: InventoryManager = $InventoryManager
@onready var party_manager: PartyManager = $PartyManager

@onready var gold_ui: HBoxContainer = %GoldUI
@onready var inventory_button: TextureButton = %InventoryButton

@onready var current_view: Node = $CurrentView
@onready var map: Node2D = $Map
@onready var inventory_ui: InventoryUI = $TopBar/InventoryUI


func _ready() -> void:
	if not run_stats:
		run_stats = RunStats.new()
	
	_set_up_managers()
	_set_up_top_bar()
	_set_up_event_connections()


func _set_up_managers() -> void:
	inventory_manager.run_stats = run_stats
	party_manager.run_stats = run_stats


func _set_up_event_connections() -> void:
	Events.battle_exited.connect(_show_map)
	Events.shop_exited.connect(_show_map)
	Events.brewing_exited.connect(_show_map)
	Events.kiln_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)


func _set_up_top_bar() -> void:
	inventory_button.pressed.connect(inventory_ui.toggle_view)
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


func _on_map_exited(room_name: String) -> void:
	# TODO replace with room type matching
	
	match room_name:
		'battle':
			_on_battle_entered()
		'shop':
			_on_shop_entered()
		'brewing':
			_on_brewing_entered()
		'kiln':
			_on_kiln_entered()


func _on_battle_entered() -> void:
	_change_view(BATTLE_SCENE)


func _on_shop_entered() -> void:
	var shop := _change_view(SHOP_SCENE)
	shop.inventory_manager = inventory_manager
	shop.populate_shop()
	Events.shop_entered.emit(shop)


func _on_brewing_entered() -> void:
	var brewing := _change_view(BREWING_SCENE)
	brewing.inventory_manager = inventory_manager
	Events.brewing_entered.emit(brewing)


func _on_kiln_entered() -> void:
	var kiln := _change_view(KILN_SCNE)
	kiln.party_manager = party_manager
	
