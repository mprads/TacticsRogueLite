extends HBoxContainer
class_name InventoryUnitUI

const FILLING_SHEET = preload("res://assets/sprites/potions/filling_sheet.png")
const OUTLINE_SHEET = preload("res://assets/sprites/potions/outline_sheet.png")

@export var unit: UnitStats : set = _set_unit

@onready var potion: TextureRect = $UnitIconPanel/InventoryUnitIcon/Potion
@onready var bottle: TextureRect = $UnitIconPanel/InventoryUnitIcon/Bottle
@onready var label: Label = $UnitDetailsPanel/Label


func _set_unit(value: UnitStats) -> void:
	unit = value
	
	_set_visuals()
	_set_details()


func _set_visuals() -> void:
	if unit:
		var coords = unit.bottle.sprite_coordinates
		var size = unit.bottle.sprite_size

		var outline = AtlasTexture.new()
		var filling = AtlasTexture.new()
		outline.set_atlas(OUTLINE_SHEET)
		outline.region = Rect2(coords[0] * size, coords[1] * size, size, size)
		filling.set_atlas(FILLING_SHEET)
		filling.region = Rect2(coords[0] * size, coords[1] * size, size, size)
		
		bottle.texture = outline
		potion.texture = filling
		
		if unit.potion:
			potion.modulate = unit.potion.color
		else:
			potion.visible = false
	else:
		bottle.texture = null
		potion.texture = null


func _set_details() -> void:
	if unit:
		var string = "HP: %s / %s \nOZ: %s / %s"
		label.text =  string % [str(unit.health), str(unit.max_health), str(unit.oz), str(unit.max_oz)]
		
