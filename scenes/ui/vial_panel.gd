extends Button
class_name VialPanel

@export var potion: Potion : set = _potion

@onready var label: Label = %Label
@onready var attack_container: HBoxContainer = %AttackContainer

@onready var header: Panel = %Header
@onready var border: Panel = %Border
@onready var header_sb: StyleBoxFlat = header.get_theme_stylebox("panel")
@onready var border_sb: StyleBoxFlat = border.get_theme_stylebox("panel")


func _update_visuals() -> void:
	label.text = "%s Vial" %potion.name
	header_sb.bg_color = potion.color
	border_sb.border_color = potion.color


func _potion(value: Potion) -> void:
	if not is_node_ready():
		await ready

	potion = value
	
	if not potion: return
	
	_update_visuals()
