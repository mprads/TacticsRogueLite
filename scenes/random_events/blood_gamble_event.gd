class_name BloodGambleEvent
extends Node2D

@export var party_manager: PartyManager : set = set_party_manager

@export var min_gold := 50
@export var max_gold := 200
@export var starting_damage := 5
@export var damage_increment := 10
@export var label_text := "Sacrifice %s life"

@onready var pay_life_button: Button = %PayLifeButton
@onready var leave_button: Button = %LeaveButton
@onready var party_ui: PartyUI = %PartyUI
@onready var cost_label: Label = %CostLabel

var damage = starting_damage


func _ready() -> void:
	pay_life_button.pressed.connect(_on_pay_life_button_pressed)
	leave_button.pressed.connect(Events.random_event_exited.emit)
	party_ui.unit_selected.connect(_on_united_selected)


func set_party_manager(value: PartyManager) -> void:
	party_manager = value
	party_ui.party_manager = value


func _on_pay_life_button_pressed() -> void:
	pay_life_button.hide()
	leave_button.disabled = true
	cost_label.text = label_text % damage
	cost_label.show()
	party_ui.show()


func _on_united_selected(unit: UnitStats) -> void:
	if unit.health <= damage: return

	unit.take_damage(damage)

	damage += damage_increment

	var reward = RNG.instance.randi_range(min_gold, max_gold)
	Events.request_add_gold.emit(reward)

	leave_button.disabled = false
	cost_label.text = label_text % damage
