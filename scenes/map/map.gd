@tool
extends Node2D
class_name Map

@export_tool_button("GenerateMap")
var toolbutton_generate_map = generate_new_map

@onready var battle_button: Button = $UI/VBoxContainer/BattleButton
@onready var shop_button: Button = $UI/VBoxContainer/ShopButton
@onready var brewing_button: Button = $UI/VBoxContainer/BrewingButton
@onready var kiln_button: Button = $UI/VBoxContainer/KilnButton

@onready var ui: CanvasLayer = $UI

@onready var visuals: Node2D = %Visuals
@onready var lines: Node2D = %Lines
@onready var rooms: Node2D = %Rooms
@onready var map_generator: MapGenerator = %MapGenerator


var map_data: Array[Array]
var floors_climbed: int

func _ready() -> void:
	battle_button.pressed.connect(_on_room_selected.bind('battle'))
	shop_button.pressed.connect(_on_room_selected.bind('shop'))
	brewing_button.pressed.connect(_on_room_selected.bind('brewing'))
	kiln_button.pressed.connect(_on_room_selected.bind('kiln'))


func generate_new_map() -> void:
	floors_climbed = 0
	map_data = map_generator.generate_map()
	print(map_data)
	#create_map()


func show_map() -> void:
	ui.show()


func hide_map() -> void:
	ui.hide()


func _on_room_selected(room: String) -> void:
	Events.map_exited.emit(room)
