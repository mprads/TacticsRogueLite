class_name StartingItemPanel
extends Panel

const STARTING_ITEM_PANEL_SCENE = preload("uid://x7wbmg7h50ei")
const GOLD_ICON = preload("uid://8dorcsr83rfq")

@onready var vial_button: VialButton = %VialButton
@onready var artifact_icon: ArtifactIcon = %ArtifactIcon
@onready var icon: TextureRect = %Icon
@onready var content_label: Label = %ContentLabel

var lineitem:
	set = set_lineitem


func set_lineitem(value: Variant) -> void:
	if not is_node_ready():
		await ready

	lineitem = value
	_update_visuals()


func _update_visuals() -> void:
	if lineitem.item is Item:
		icon.texture = lineitem.item.icon
		content_label.text = "%s %s" %[str(lineitem.quantity), lineitem.item.name]
	elif lineitem.item is Vial:
		icon.visible = false
		vial_button.visible = true
		vial_button.vial = lineitem.item
		content_label.text = lineitem.item.potion.name
	elif lineitem.item is Artifact:
		icon.visible = false
		artifact_icon.visible = true
		artifact_icon.artifact = lineitem.item
		content_label.text = str(lineitem.item.name)
	else:
		icon.texture = GOLD_ICON
		content_label.text = "%s Gold"  % str(lineitem.quantity)


static func create_new(new_lineitem: Variant) -> StartingItemPanel:
	var new_starting_item_panel := STARTING_ITEM_PANEL_SCENE.instantiate()
	new_starting_item_panel.lineitem = new_lineitem

	return new_starting_item_panel
