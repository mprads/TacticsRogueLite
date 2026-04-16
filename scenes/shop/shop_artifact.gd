class_name ShopArtifact
extends Control

const SHOP_ARTIFACT_SCENE = preload("uid://c1xgosjtjf1n3")

@export var artifact: Artifact : set = set_artifact
@export var outline_thickness: float = 1.0

@onready var artifact_icon_button: TextureButton = %ArtifactIconButton
@onready var gold_cost: Label = %GoldCost
@onready var artifact_container: VBoxContainer = %ArtifactContainer
@onready var discont_tag: Control = %DiscontTag
@onready var discount_gold_cost: Label = %DiscountGoldCost
@onready var upcharge_tag: Control = %UpchargeTag
@onready var upcharge_gold_cost: Label = %UpchargeGoldCost



func _ready() -> void:
	artifact_icon_button.pressed.connect(_on_purchase_artifact)
	artifact_icon_button.mouse_entered.connect(_on_mouse_entered)
	artifact_icon_button.mouse_exited.connect(_on_mouse_exited)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func update_gold_cost(change: float) -> void:
	if not artifact or not change:
		return

	var new_cost := floori(artifact.gold_cost * change)
	if new_cost > artifact.gold_cost:
		upcharge_tag.visible = true
	elif new_cost < artifact.gold_cost:
		discont_tag.visible = true
	
	artifact.update_gold_cost(floori(artifact.gold_cost * change))


func update(player_gold: int) -> void:
	if not is_node_ready():
		await ready

	if not artifact or not artifact_container: return

	var artifact_gold_cost = str(artifact.gold_cost)
	gold_cost.text = artifact_gold_cost
	discount_gold_cost.text = artifact_gold_cost
	upcharge_gold_cost.text = artifact_gold_cost

	if artifact.gold_cost > player_gold:
		artifact_icon_button.disabled = true
		gold_cost.modulate = Color.RED
		discount_gold_cost.modulate = Color.RED
		upcharge_gold_cost.modulate = Color.RED
	else:
		artifact_icon_button.disabled = false
		gold_cost.modulate = Color.WHITE
		discount_gold_cost.modulate = Color.WHITE
		upcharge_gold_cost.modulate = Color.WHITE


func set_artifact(value: Artifact) -> void:
	if not is_node_ready():
		await ready

	artifact = value

	var artifact_gold_cost = str(artifact.gold_cost)
	gold_cost.text = artifact_gold_cost
	discount_gold_cost.text = artifact_gold_cost
	upcharge_gold_cost.text = artifact_gold_cost
	artifact_icon_button.texture_normal = artifact.icon
	artifact_icon_button.texture_disabled = artifact.icon


func _on_purchase_artifact() -> void:
	artifact_container.queue_free()
	discont_tag.queue_free()
	upcharge_tag.queue_free()
	Events.request_purchase_artifact.emit(artifact)


func _on_mouse_entered() -> void:
	if not artifact or not artifact_container: return

	artifact_icon_button.material.set_shader_parameter('outline_thickness', outline_thickness)
	var main_tooltip := { "name": artifact.name, "description": artifact.get_tooltip() }
	var secondary := []

	if artifact.get("status") :
		var status_tooltip := {
			"name": artifact.status.name,
			"description": artifact.status.get_tooltip()
		}
		secondary.append(status_tooltip)

	Events.request_show_tooltip.emit(self, main_tooltip, secondary)


func _on_mouse_exited() -> void:
	if not artifact or not artifact_container: return

	artifact_icon_button.material.set_shader_parameter('outline_thickness', 0.0)
	Events.hide_tooltip.emit()


static func create_new(new_artifact: Artifact) -> ShopArtifact:
	var new_shop_artifact := SHOP_ARTIFACT_SCENE.instantiate()
	new_shop_artifact.artifact = new_artifact
	return new_shop_artifact
