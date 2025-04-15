extends Area2D
class_name Unit

signal movement_complete
signal movement_cancelled
signal aim_started(ability: Ability)
signal aim_stopped
signal ability_selected(ability: Ability)
signal turn_complete
signal request_change_active_unit
signal unit_selected(unit: Unit)

@export var stats: UnitStats : set = set_stats

@onready var visuals: CanvasGroup = $Visuals
@onready var outline: Sprite2D = $Visuals/Outline
@onready var filling: Sprite2D = $Visuals/Filling

@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var unit_state_machine: UnitStateMachine = $UnitStateMachine
@onready var status_manager: StatusManager = $StatusManager
@onready var modifier_manager: ModifierManager = $ModifierManager

@onready var moveable_debug: Label = $MoveableDebug

var moveable := true : set = set_moveable
var disabled := false : set = set_disabled
var selectable := false

var selected_ability: Ability


func _ready() -> void:
	unit_state_machine.init(self)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _input(event: InputEvent) -> void:
	unit_state_machine.on_input(event)


func take_damage(damage: int) -> void:
	if not stats: return

	var modified_damage = modifier_manager.get_modified_value(damage, Modifier.TYPE.DAMAGE_TAKEN)
	stats.take_damage(modified_damage)


func move_cleanup() -> void:
	unit_state_machine.on_movement_complete()


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
	else:
		filling.visible = false


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


func _on_mouse_entered() -> void:
	unit_state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	unit_state_machine.on_mouse_exited()
