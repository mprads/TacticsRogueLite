extends Button
class_name RewardButton

@export var reward_icon: Texture2D : set = set_reward_icon
@export var reward_text: String : set= set_reward_text

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
