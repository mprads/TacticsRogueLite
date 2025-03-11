extends Node
class_name Run

const BATTLE_SCENE := preload("res://scenes/battle/battle.tscn")
const SHOP_SCENE := preload("res://scenes/shop/shop.tscn")
const BREWING_SCENE := preload("res://scenes/brewing/brewing.tscn")
const KILN_SCNE := preload("res://scenes/kiln/kiln.tscn")

@onready var current_view: Node = $CurrentView
@onready var map: Node2D = $Map


func _ready() -> void:
	Events.battle_exited.connect(_show_map)
	Events.shop_exited.connect(_show_map)
	Events.brewing_exited.connect(_show_map)
	Events.kiln_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)


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
	_change_view(SHOP_SCENE)


func _on_brewing_entered() -> void:
	_change_view(BREWING_SCENE)


func _on_kiln_entered() -> void:
	_change_view(KILN_SCNE)
