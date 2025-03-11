extends Node2D
class_name Map

@onready var battle_button: Button = $UI/VBoxContainer/BattleButton
@onready var shop_button: Button = $UI/VBoxContainer/ShopButton
@onready var brewing_button: Button = $UI/VBoxContainer/BrewingButton
@onready var kiln_button: Button = $UI/VBoxContainer/KilnButton

@onready var ui: CanvasLayer = $UI


func _ready() -> void:
	battle_button.pressed.connect(_on_room_selected.bind('battle'))
	shop_button.pressed.connect(_on_room_selected.bind('shop'))
	brewing_button.pressed.connect(_on_room_selected.bind('brewing'))
	kiln_button.pressed.connect(_on_room_selected.bind('kiln'))


func show_map() -> void:
	ui.show()


func hide_map() -> void:
	ui.hide()


func _on_room_selected(room: String) -> void:
	Events.map_exited.emit(room)
