class_name Map
extends Node2D

const SLOW_SCROLL_SPEED := 5
const FAST_SCROLL_SPEED := 15
const SLOW_SCROLL_THRESHOLD := 100
const FAST_SCROLL_THRESHOLD := 40
const MAP_ROOM = preload("res://scenes/map/map_room.tscn")
const MAP_LINE = preload("res://scenes/map/map_line.tscn")

@onready var camera_2d: Camera2D = $Camera2D
@onready var visuals: Node2D = %Visuals
@onready var lines: Node2D = %Lines
@onready var rooms: Node2D = %Rooms
@onready var map_generator: MapGenerator = %MapGenerator
@onready var map_texture_panel: Panel = %MapTexturePanel
@onready var background: CanvasLayer = %Background

var map_data: Array[Array]
var encounters: int
var last_room: Room
var camera_edge_x: float
var viewport_size: Vector2


func _ready() -> void:
	# TODO find a better value to clamp max
	viewport_size = get_viewport_rect().size
	camera_edge_x = (MapGenerator.X_DIST * (MapGenerator.TOTAL_ENCOUNTERS + .5)) - viewport_size.x


func _process(_delta: float) -> void:
	if not visible:
		return

	var mouse_position: Vector2 = get_viewport().get_mouse_position()

	if mouse_position.x >= viewport_size.x - FAST_SCROLL_THRESHOLD:
		camera_2d.position.x += FAST_SCROLL_SPEED
		map_texture_panel.position.x -= FAST_SCROLL_SPEED
	elif mouse_position.x >= viewport_size.x - SLOW_SCROLL_THRESHOLD:
		camera_2d.position.x += SLOW_SCROLL_SPEED
		map_texture_panel.position.x -= SLOW_SCROLL_SPEED
	elif mouse_position.x <= FAST_SCROLL_THRESHOLD:
		camera_2d.position.x -= FAST_SCROLL_SPEED
		map_texture_panel.position.x += FAST_SCROLL_SPEED
	elif mouse_position.x <= SLOW_SCROLL_THRESHOLD:
		camera_2d.position.x -= SLOW_SCROLL_SPEED
		map_texture_panel.position.x += SLOW_SCROLL_SPEED

	camera_2d.position.x = clamp(camera_2d.position.x, 0, camera_edge_x)
	map_texture_panel.position.x = clamp(map_texture_panel.position.x, -(map_texture_panel.size.x - viewport_size.x), 0)


func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("scroll_up"):
		camera_2d.position.x += FAST_SCROLL_SPEED
		map_texture_panel.position.x -= FAST_SCROLL_SPEED
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.x -= FAST_SCROLL_SPEED
		map_texture_panel.position.x += FAST_SCROLL_SPEED

	camera_2d.position.x = clamp(camera_2d.position.x, 0, camera_edge_x)
	map_texture_panel.position.x = clamp(map_texture_panel.position.x, -(map_texture_panel.size.x - viewport_size.x), 0)


func generate_new_map() -> void:
	encounters = 0
	map_data = map_generator.generate_map()
	_create_map()
	map_texture_panel.size.x = MapGenerator.X_DIST * MapGenerator.TOTAL_ENCOUNTERS


func show_map() -> void:
	show()
	camera_2d.enabled = true
	background.visible = true


func hide_map() -> void:
	hide()
	camera_2d.enabled = false
	background.visible = false


func unlock_row(row: int = encounters) -> void:
	for map_room in rooms.get_children():
		if map_room.room.row == row:
			map_room.available = true


func unlock_next_rooms() -> void:
	for map_room in rooms.get_children():
		if last_room.next_rooms.has(map_room.room):
			map_room.available = true


func _create_map() -> void:
	for current_floor in map_data:
		for room in current_floor:
			if room.next_rooms.size() > 0:
				_spawn_room(room)

	var middle := floori(MapGenerator.MAP_HEIGHT * 0.5)
	_spawn_room(map_data[MapGenerator.TOTAL_ENCOUNTERS - 1][middle])


func _unlock_next_rooms() -> void:
	for map_room in rooms.get_children():
		if last_room.next_rooms.has(map_room.room):
			map_room.available = true


func _spawn_room(room: Room) -> void:
	var map_room_instance := MAP_ROOM.instantiate()
	rooms.add_child(map_room_instance)
	map_room_instance.room = room
	map_room_instance.selected.connect(_on_map_room_selected)
	_connect_lines(room)


func _connect_lines(room: Room) -> void:
	if room.next_rooms.is_empty():
		return

	for next_room in room.next_rooms:
		var line_instance := MAP_LINE.instantiate()
		line_instance.add_point(room.position)
		line_instance.add_point(next_room.position)
		lines.add_child(line_instance)


func _on_map_room_selected(room: Room) -> void:
	for map_room in rooms.get_children():
		if map_room.room.row == room.row:
			map_room.available = false

	last_room = room
	encounters += 1
	Events.map_exited.emit(room)


func _on_button_shortcut(room: String) -> void:
	Events.map_exited.emit(room)
