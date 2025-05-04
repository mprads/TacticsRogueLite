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
	var main_tooltip := { "name": ability.name, "description": ability.get_tooltip() }
	var secondary := []

	if ability.get("status") :
		var status_tooltip := {
			"name": ability.status.name,
			"description": ability.status.get_tooltip()
		}
		secondary.append(status_tooltip)

	Events.request_show_tooltip.emit(self, main_tooltip, secondary)


func _on_mouse_exited() -> void:
	Events.hide_tooltip.emit()
