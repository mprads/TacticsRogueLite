class_name TooltipPanel
extends Panel

const TOOLTIP_PANEL_SCENE = preload("uid://4pft6ahlavju")

@onready var name_label: Label = %NameLabel
@onready var description_label: RichTextLabel = %DescriptionLabel


func update_visuals(header: String, description: String) -> void:
	if not is_node_ready():
		await ready

	name_label.text = header
	description_label.text = description


static func create_new(header: String, description: String) -> TooltipPanel:
	var new_tooltip_panel := TOOLTIP_PANEL_SCENE.instantiate()
	new_tooltip_panel.update_visuals(header, description)
	return new_tooltip_panel
