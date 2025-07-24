class_name RestArea
extends Node2D

@export var party_manager: PartyManager : set = set_party_manager

@onready var kiln_button: Button = %KilnButton
@onready var brewing_button: Button = %BrewingButton


func set_party_manager(value: PartyManager) -> void:
	if not is_node_ready():
		await ready

	party_manager = value
