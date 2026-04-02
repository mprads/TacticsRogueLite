class_name DilapidatedLab
extends Node2D

@export var vial_manager: VialManager : set = set_vial_manager
@export var potions: Array[Potion]
@export var count := 5

@onready var vial_container: VBoxContainer = %VialContainer


func set_vial_manager(value: VialManager) -> void:
	if not is_node_ready():
		await ready

	vial_manager = value

	for child in vial_container.get_children():
		child.queue_free()

	for option in count:
		_generate_option()


func _generate_option() -> void:
	var potion: Potion = RNG.array_pick_random(potions)
	var new_button := VialSelectButton.create_new(potion)
	vial_container.add_child(new_button)
	new_button.pressed.connect(_on_button_pressed.bind(new_button))


func _on_button_pressed(button: VialSelectButton) -> void:
	var new_vial := Vial.new()
	new_vial.potion = button.potion
	button.queue_free()
	vial_manager.add_vial(new_vial)
