extends PanelContainer
class_name UnitSelectPanel

const ABILITY_PANEL = preload("res://scenes/ui/ability_panel.tscn")
const STARTING_ITEM_PANEL = preload("res://scenes/party_select/starting_item_panel.tscn")

@export var unit: Unit : set = set_unit

@onready var ability_container: HBoxContainer = %AbilityContainer
@onready var party_unit_ui: PartyUnitUI = %PartyUnitUI


func set_unit(value: Unit) -> void:
	unit = value
