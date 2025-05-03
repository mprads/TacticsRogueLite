extends Panel
class_name AbilityPanel

@export var ability: Ability : set = set_ability

@onready var ability_label: Label = %AbilityLabel


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func set_ability(value: Ability) -> void:
	ability = value
	ability_label.text = ability.name


func _on_mouse_entered() -> void:
	Events.request_show_tooltip.emit(ability.name, ability.get_tooltip(), global_position)


func _on_mouse_exited() -> void:
	Events.hide_tooltip.emit()
