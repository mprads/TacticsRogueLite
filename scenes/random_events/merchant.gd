class_name Merchant
extends Node2D

@export var shop_artifacts: Array[Artifact]

@export var artifact_manager: ArtifactManager : set = set_artifact_manager
@export var party_manager: PartyManager : set = set_party_manager
@export var inventory_manager: InventoryManager : set = set_inventory_manager

@onready var available_artifacts := shop_artifacts

var purchase_made := false


func set_party_manager(value: PartyManager) -> void:
	party_manager = value


func set_artifact_manager(value: ArtifactManager) -> void:
	artifact_manager = value
	var current_artifacts = artifact_manager.get_artifacts()

	for artifact in current_artifacts:
		if available_artifacts.has(artifact):
			available_artifacts.erase(artifact)


func set_inventory_manager(value: InventoryManager) -> void:
	inventory_manager = value

	if not inventory_manager.gold_changed.is_connected(_on_inventory_gold_changed):
		inventory_manager.gold_changed.connect(_on_inventory_gold_changed)
		_on_inventory_gold_changed()


func _on_inventory_gold_changed() -> void:
	pass
