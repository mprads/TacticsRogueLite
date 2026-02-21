class_name UnitSelectPanel
extends PanelContainer

signal panel_selected(unit_stats: UnitStats, items: Array)

const UNIT_SELECT_PANEL_SCENE = preload("uid://cjdocmvvhnve6")

@export var unit_stats: UnitStats : set = set_unit_stats
@export var contents: Array : set = set_contents

@onready var unit_icon_panel: UnitIconPanel = %UnitIconPanel
@onready var unit_details_panel: UnitDetailsPanel = %UnitDetailsPanel
@onready var ability_container: VBoxContainer = %AbilityContainer
@onready var contents_container: VBoxContainer = %ContentsContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var disabled := false


func _ready() -> void:
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)

	_play_animation("in")


func set_disabled() -> void:
	disabled = true


func play_discard() -> void:
	_play_animation("discard")


func _update_ability_visuals() -> void:
	for child in ability_container.get_children():
		child.queue_free()

	if not unit_stats.potion: return

	for ability in unit_stats.potion.abilities:
		var ability_panel_instance := AbilityPanel.create_new(ability)
		ability_container.add_child(ability_panel_instance)


func _play_animation(id: String) -> void:
	if disabled: return

	if animation_player.is_playing() and not animation_player.current_animation == id:
		animation_player.queue(id)
	else:
		animation_player.play(id)


func set_unit_stats(value: UnitStats) -> void:
	if not is_node_ready():
		await ready

	unit_stats = value
	unit_icon_panel.unit_stats = unit_stats
	unit_details_panel.unit_stats = unit_stats

	_update_ability_visuals()


func set_contents(value: Array) -> void:
	contents = value

	for lineitem in contents:
		var item_panel_instance := StartingItemPanel.create_new(lineitem)
		contents_container.add_child(item_panel_instance)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		_play_animation("selected")
		panel_selected.emit(unit_stats, contents)


func _on_mouse_entered() -> void:
	_play_animation("hover")


static func create_new(new_stats: UnitStats) -> UnitSelectPanel:
	var new_unit_select_panel := UNIT_SELECT_PANEL_SCENE.instantiate()
	new_unit_select_panel.unit_stats = new_stats
	return new_unit_select_panel
