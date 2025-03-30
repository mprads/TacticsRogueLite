extends Area2D
class_name Unit

signal turn_complete

@export var stats: UnitStats : set = set_stats

@onready var visuals: CanvasGroup = $Visuals
@onready var outline: Sprite2D = $Visuals/Outline
@onready var filling: Sprite2D = $Visuals/Filling

@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var unit_state_machine: UnitStateMachine = $UnitStateMachine

@onready var moveable_debug: Label = $MoveableDebug

var moveable := true : set = set_moveable
var disabled := false : set = set_disabled


func _ready() -> void:
	unit_state_machine.init(self)


func _input(event: InputEvent) -> void:
	unit_state_machine.on_input(event)


func set_stats(value: UnitStats) -> void:
	stats = value
	
	if value == null:
		return
	
	if not is_node_ready():
		await ready

	outline.region_rect.position = Vector2(stats.bottle.sprite_coordinates) * 32
	filling.region_rect.position = Vector2(stats.bottle.sprite_coordinates) * 32
	
	if stats.potion:
		filling.visible = true
		filling.modulate = stats.potion.color


func set_moveable(value: bool) -> void:
	moveable = value
	if moveable:
		moveable_debug.text = "Moveable" 
	else:
		moveable_debug.text = "Moved"


func set_disabled(value: bool) -> void:
	disabled = value
	
	if disabled:
		visuals.modulate = Color("3a3a3a")
	else:
		visuals.modulate = Color.WHITE
