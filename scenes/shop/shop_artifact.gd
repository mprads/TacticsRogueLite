extends Control
class_name ShopArtifact

@export var artifact: Artifact : set = set_artifact

@onready var artifact_icon_button: TextureButton = %ArtifactIconButton
@onready var gold_cost: Label = %GoldCost
@onready var artifact_container: VBoxContainer = %ArtifactContainer


func _ready() -> void:
	artifact_icon_button.pressed.connect(_on_purchase_artifact)


func update(player_gold: int) -> void:
	if not artifact or not artifact_container: return

	gold_cost.text = str(artifact.gold_cost)

	if artifact.gold_cost > player_gold:
		artifact_icon_button.disabled = true
		gold_cost.modulate = Color.RED
	else:
		artifact_icon_button.disabled = false
		gold_cost.modulate = Color.WHITE


func set_artifact(value: Artifact) -> void:
	if not is_node_ready():
		await ready

	artifact = value

	gold_cost.text = str(artifact.gold_cost)
	artifact_icon_button.texture_normal = artifact.icon
	artifact_icon_button.texture_disabled = artifact.icon


func _on_purchase_artifact() -> void:
	artifact_container.queue_free()
	Events.request_purchase_artifact.emit(artifact)
