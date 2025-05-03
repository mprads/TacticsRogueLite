extends Panel
class_name Tooltip

@onready var name_label: Label = %NameLabel
@onready var description_label: RichTextLabel = %DescriptionLabel


func _ready() -> void:
	Events.request_show_tooltip.connect(_on_request_show_tooltip)
	Events.hide_tooltip.connect(_on_hide_tooltip)


func _on_request_show_tooltip(name: String, description: String, position: Vector2) -> void:
	global_position = position
	name_label.text = name
	description_label.text = description
	visible = true


func _on_hide_tooltip() -> void:
	global_position = Vector2.ZERO
	name_label.text = ""
	description_label.text = ""
	visible = false
	
