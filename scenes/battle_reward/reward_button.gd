class_name RewardButton
extends Button

const REWARD_BUTTON_SCENE = preload("uid://dueqwsk87m66w")
const GOLD_ICON = preload("uid://8dorcsr83rfq")

@export var reward_icon: Texture2D:
	set = set_reward_icon
@export var reward_text: String:
	set = set_reward_text

@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var label: Label = $MarginContainer/HBoxContainer/Label


func _ready() -> void:
	pressed.connect(queue_free)


func set_reward_icon(value: Texture2D) -> void:
	reward_icon = value

	if not is_node_ready():
		await ready

	texture_rect.texture = reward_icon


func set_reward_text(value: String) -> void:
	reward_text = value

	if not is_node_ready():
		await ready

	label.text = reward_text


static func create_new(new_text: String, new_icon: Texture2D = GOLD_ICON) -> RewardButton:
	var new_reward_button := REWARD_BUTTON_SCENE.instantiate()
	new_reward_button.reward_text = new_text
	new_reward_button.reward_icon = new_icon
	return new_reward_button
