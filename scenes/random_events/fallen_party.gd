class_name FallenParty
extends Node2D

@export var artifact_manager: ArtifactManager : set = set_artifact_manager
@export var party_manager: PartyManager : set = set_party_manager
@export var artifact_pool: WeightedTable
@export var gold_reward_min: int = 50
@export var gold_reward_max: int = 150
@export var artifact_chance := 0.25
@export var unit_option_count := 3

@export var bottles: Array[Bottle]
@export var potions: Array[Potion]
@export var damage_upper := 0.75
@export var damage_lower := 0.3

@onready var loot_button: Button = %LootButton
@onready var leave_button: Button = %LeaveButton
@onready var option_container: GridContainer = %OptionContainer
@onready var ui_layer: CanvasLayer = %UI


func _ready() -> void:
	loot_button.pressed.connect(_on_loot_button_pressed)
	leave_button.pressed.connect(Events.random_event_exited.emit)

	artifact_pool.setup()


func set_artifact_manager(value: ArtifactManager) -> void:
	artifact_manager = value


func set_party_manager(value: PartyManager) -> void:
	party_manager = value


func _handle_unit_reward() -> void:
	var gold_reward = RNG.instance.randi_range(gold_reward_min, gold_reward_max)
	Events.request_add_gold.emit(gold_reward)

	for unit in unit_option_count:
		var unit_stats := UnitStats.new()
		var bottle: Bottle = RNG.array_pick_random(bottles)
		var potion: Potion = RNG.array_pick_random(potions)
		unit_stats.bottle = bottle
		unit_stats.potion = potion
		unit_stats.health = RNG.instance.randi_range(
			roundi(unit_stats.max_health * damage_lower), roundi(unit_stats.max_health * damage_upper)
		)
		unit_stats.oz = RNG.instance.randi_range(
			roundi(unit_stats.max_oz * damage_lower), roundi(unit_stats.max_oz * damage_upper)
		)

		var party_select_ui := PartyUnitUI.create_new(unit_stats)
		option_container.add_child(party_select_ui)
		party_select_ui.pressed.connect(_on_unit_selected.bind(unit_stats))


func _on_loot_button_pressed() -> void:
	loot_button.disabled = true
	loot_button.visible = false

	var roll := RNG.instance.randf()
	if roll <= artifact_chance:
		var artifact_reward: Artifact = artifact_pool.get_item_in_tier(0).reward_res
		Events.request_add_artifact.emit(artifact_reward)
		Events.random_event_exited.emit()
	else:
		_handle_unit_reward()


func _on_unit_selected(unit_stats: UnitStats) -> void:
	var party := party_manager.get_party()

	if party.size() < party_manager.get_max_party_size():
		party_manager.add_unit(unit_stats)
		Events.random_event_exited.emit()
	else:
		var discard_unit_ui = DiscardUnitUI.create_new(party_manager, true)
		ui_layer.add_child(discard_unit_ui)
		discard_unit_ui.unit_removed.connect(_on_unit_removed.bind(unit_stats))


func _on_unit_removed(unit_stats: UnitStats) -> void:
	party_manager.add_unit(unit_stats)
	Events.random_event_exited.emit()
