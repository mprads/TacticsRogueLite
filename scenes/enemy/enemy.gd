class_name Enemy
extends Area2D

signal request_enemy_move(tile: Vector2i)
signal turn_completed
signal enemy_selected(enemy: Enemy)
signal show_intent(enemy: Enemy)
signal request_clear_intent
signal request_flood_fill(max_distance: int, atlas_coord: Vector2i)
signal request_clear_fill_layer

@export var stats: EnemyStats : set = set_enemy_stats
@export var ai: EnemyAI : set = set_enemy_ai
@export var outline_thickness: float = 1.0
@onready var activate_ability_animated_sprite: AnimatedSprite2D = %ActivateAbilityAnimatedSprite


@onready var status_manager: StatusManager = $StatusManager
@onready var modifier_manager: ModifierManager = $ModifierManager
@onready var floating_text_spawner: FloatingTextSpawner = $FloatingTextSpawner

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var health_bar: ProgressBar = $HealthBar
@onready var shield_bar: ProgressBar = $ShieldBar

var selectable := false


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	status_manager.status_owner = self


func _input(event: InputEvent) -> void:
	if not selectable: return

	if event.is_action_pressed("left_mouse"):
		enemy_selected.emit(self)


func take_damage(damage: int) -> void:
	if not stats: return

	var modified_damage = modifier_manager.get_modified_value(damage, Modifier.TYPE.DAMAGE_TAKEN)
	stats.take_damage(modified_damage)
	spawn_floating_text(str(modified_damage), ColourHelper.get_colour(ColourHelper.KEYS.DAMAGE))

	if stats.health <= 0:
		_death_cleanup()


func spawn_floating_text(text: String, text_color) -> void:
	if not floating_text_spawner: return

	floating_text_spawner.spawn_text(text, text_color)


func move_cleanup() -> void:
	if ai.selected_ability:
		var ability_target:Array[Area2D] = [ai.current_target]
		# TODO add to ai ability to self target for buffs
		if not ai.in_range:
			ability_target = [self]
		if ai.selected_ability.target == Ability.TARGET.AOE:
			ability_target = ai.aoe_targets
		use_ability(ai.selected_ability, ability_target)
	else:
		turn_completed.emit()


func update_enemy() -> void:
	if not stats: return
	if not is_node_ready(): await ready

	sprite_2d.texture = stats.sprite
	health_bar.max_value = stats.max_health
	health_bar.value = stats.health
	shield_bar.max_value = stats.max_health
	shield_bar.value = stats.shield


func take_turn() -> void:
	request_enemy_move.emit(ai.next_tile)


func use_ability(ability: Ability, targets: Array[Area2D]) -> void:
	if ability.sprite_frames:
		for target in targets:
			if target is Unit or target is Enemy:
				target.activate_ability_animated_sprite.set_and_play(ability.sprite_frames, "activate")
		await targets[0].activate_ability_animated_sprite.animation_finished
	ability.apply_effects(targets, modifier_manager)
	turn_completed.emit()


func set_enemy_stats(value: EnemyStats) -> void:
	stats = value

	if not stats: return
	if not stats.changed.is_connected(_on_stats_changed):
		stats.changed.connect(_on_stats_changed)

	update_enemy()


func set_enemy_ai(value: EnemyAI) -> void:
	ai = value
	ai.owner = self


func _death_cleanup() -> void:
	Events.enemy_died.emit(self)
	request_clear_fill_layer.emit()
	request_clear_intent.emit()
	queue_free()


func _on_stats_changed() -> void:
	update_enemy()


func _on_mouse_entered() -> void:
	sprite_2d.material.set_shader_parameter('outline_thickness', outline_thickness)
	selectable = true
	# Clunky but when two enemies are next to each other the area2ds overlap
	# and mouse entered signal seems to have priority over exit signal
	# so create a lambda and delay till end of frame
	(func():
		request_flood_fill.emit(stats.movement, Vector2i(2, 0))

		if ai.current_target:
			show_intent.emit(self)
		).call_deferred()


func _on_mouse_exited() -> void:
	sprite_2d.material.set_shader_parameter('outline_thickness', 0.0)
	selectable = false
	request_clear_fill_layer.emit()
	request_clear_intent.emit()
