class_name UnitFillUI
extends Control

const ABILITY_PANEL_SCENE = preload("res://scenes/ui/ability_panel.tscn")

@export var vial: Vial:
	set = set_vial
@export var party_manager: PartyManager:
	set = set_party_manager

@onready var vial_button: VialButton = %VialButton
@onready var ability_container: HBoxContainer = %AbilityContainer
@onready var party_ui: PartyUI = %PartyUI
@onready var cancel_label: Label = %CancelLabel


func _ready() -> void:
	party_ui.unit_selected.connect(_on_unit_selected)

	var keycode = Utils.get_keycode_from_input_id("cancel")
	cancel_label.text = "Press [%s] to cancel" % keycode


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		vial = null
		visible = false


func toggle_view() -> void:
	visible = !visible


func set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value
	party_ui.party_manager = party_manager


func set_vial(value: Vial) -> void:
	if not is_node_ready():
		await ready

	vial = value

	if not vial:
		return

	vial_button.vial = vial
	_update_abilities()


func _update_abilities() -> void:
	for child in ability_container.get_children():
		child.queue_free()

	for ability in vial.potion.abilities:
		var ability_panel_instance := ABILITY_PANEL_SCENE.instantiate()
		ability_container.add_child(ability_panel_instance)
		ability_panel_instance.ability = ability


func _on_unit_selected(unit_stats: UnitStats) -> void:
	if unit_stats.potion:
		if unit_stats.potion == vial.potion:
			unit_stats.refill(floori(unit_stats.max_oz / 2))
		else:
			unit_stats.potion = vial.potion
			unit_stats.oz = floori(unit_stats.max_oz / 2)
	else:
		unit_stats.potion = vial.potion
		unit_stats.oz = floori(unit_stats.max_oz / 2)

	Events.run_stats_potion_used.emit(vial.potion)
	vial.potion = null
	vial = null
	visible = false
