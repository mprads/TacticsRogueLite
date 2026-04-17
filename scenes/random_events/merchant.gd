class_name Merchant
extends Node2D

@export var shop_artifacts: Array[Artifact]
@export var no_purchase_curse: Artifact
@export var option_count := 4
@export var merchant_upcharge := 1.25

@export var artifact_manager: ArtifactManager : set = set_artifact_manager
@export var party_manager: PartyManager : set = set_party_manager
@export var inventory_manager: InventoryManager : set = set_inventory_manager

@onready var item_shelf: HBoxContainer = %ItemShelf
@onready var leave_button: Button = %LeaveButton

var purchase_made := false


func _ready() -> void:
	Events.request_purchase_artifact.connect(_on_request_purchase_artifact)
	leave_button.pressed.connect(_on_leave_button_pressed)


func set_party_manager(value: PartyManager) -> void:
	party_manager = value


func set_artifact_manager(value: ArtifactManager) -> void:
	artifact_manager = value
	_generate_shop_artifacts()


func set_inventory_manager(value: InventoryManager) -> void:
	inventory_manager = value

	if not inventory_manager.gold_changed.is_connected(_on_inventory_gold_changed):
		inventory_manager.gold_changed.connect(_on_inventory_gold_changed)
		_on_inventory_gold_changed()


func _generate_shop_artifacts() -> void:
	if not is_node_ready():
		await ready

	for child in item_shelf.get_children():
		child.queue_free()
	
	var player_artifacts := artifact_manager.get_artifacts()
	var filtered_artifacts := shop_artifacts.duplicate()
	for artifact in player_artifacts:
		filtered_artifacts.erase(artifact)

	for index in clampi(filtered_artifacts.size(), 0, option_count):
		var selected_artifact = RNG.array_pick_random(filtered_artifacts)
		var shop_artifact_instance := ShopArtifact.create_new(selected_artifact)
		item_shelf.add_child(shop_artifact_instance)
		filtered_artifacts.erase(selected_artifact)
		shop_artifact_instance.update_gold_cost(merchant_upcharge)
		shop_artifact_instance.update(inventory_manager.get_gold())


func _on_inventory_gold_changed() -> void:
	var player_gold := inventory_manager.get_gold()

	for shop_artifact in item_shelf.get_children():
		shop_artifact.update(player_gold)


func _on_request_purchase_artifact(_artifact: Artifact) -> void:
	purchase_made = true


func _on_leave_button_pressed() -> void:
	if not purchase_made:
		Events.request_add_artifact.emit(no_purchase_curse)

	Events.random_event_exited.emit()
