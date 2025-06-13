class_name Unit
extends Area2D

signal movement_complete
signal movement_cancelled
signal aim_started(ability: Ability)
signal aim_stopped
signal ability_selected(ability: Ability)
signal turn_complete
signal request_change_active_unit
signal unit_selected(unit: Unit)

@export var stats: UnitStats:
	set = set_stats
@export var outline_thickness: float = 1.0

@onready var visuals: CanvasGroup = $Visuals
@onready var outline: Sprite2D = $Visuals/Outline
@onready var filling: Sprite2D = $Visuals/Filling
@onready var aiming_ability_animated_sprite: AnimatedSprite2D = %AimingAbilityAnimatedSprite
@onready var activate_ability_animated_sprite: AnimatedSprite2D = %ActivateAbilityAnimatedSprite
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var unit_state_machine: UnitStateMachine = $UnitStateMachine
@onready var status_manager: StatusManager = $StatusManager
@onready var modifier_manager: ModifierManager = $ModifierManager
@onready var floating_text_spawner: FloatingTextSpawner = $FloatingTextSpawner

@onready var moveable_debug: Label = $MoveableDebug

var moveable := true:
	set = set_moveable
var disabled := false:
	set = set_disabled
var selectable := false

var selected_ability: Ability


func _ready() -> void:
	unit_state_machine.init(self)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _input(event: InputEvent) -> void:
	unit_state_machine.on_input(event)


func take_damage(damage: int) -> void:
	if not stats:
		return

	var modified_damage = modifier_manager.get_modified_value(damage, Modifier.TYPE.DAMAGE_TAKEN)

	stats.take_damage(modified_damage)
	animation_player.play("damage")
	spawn_floating_text(str(modified_damage), ColourHelper.get_colour(ColourHelper.KEYS.DAMAGE))

	if stats.health <= 0:
		Events.unit_died.emit(self)
		queue_free()


func spawn_floating_text(text: String, text_color) -> void:
	if not floating_text_spawner:
		return

	floating_text_spawner.spawn_text(text, text_color)


func move_cleanup() -> void:
	unit_state_machine.on_movement_complete()


func update_visuals() -> void:
	if not stats:
		return

	outline.texture = stats.bottle.bottle_sprite
	filling.texture = stats.bottle.liquid_mask

	if stats.potion:
		filling.visible = true
		filling.material.set_shader_parameter("Mask", stats.bottle.liquid_mask)
		filling.material.set_shader_parameter("Color", stats.potion.color)
		filling.material.set_shader_parameter("Fill", float(stats.oz) / float(stats.bottle.max_oz))
	else:
		filling.visible = false


func set_stats(value: UnitStats) -> void:
	stats = value

	if value == null:
		return

	if not is_node_ready():
		await ready

	update_visuals()


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
