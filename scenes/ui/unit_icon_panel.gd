extends Panel
class_name UnitIconPanel

const FILLING_SHEET = preload("res://assets/sprites/potions/filling_sheet.png")
const OUTLINE_SHEET = preload("res://assets/sprites/potions/outline_sheet.png")

@export var unit: UnitStats : set = set_unit

@onready var potion: TextureRect = %Potion
@onready var bottle: TextureRect = %Bottle
@onready var unit_icon: Control = $UnitIcon


func set_unit(value: UnitStats) -> void:
	unit = value

	_set_visuals()


func _set_visuals() -> void:
	if unit:
		var coords = unit.bottle.sprite_coordinates
		var sprite_size = unit.bottle.sprite_size

		var outline = AtlasTexture.new()
		var filling = AtlasTexture.new()
		outline.set_atlas(OUTLINE_SHEET)
		outline.region = Rect2(coords[0] * sprite_size,
			coords[1] * sprite_size,
			sprite_size,
			sprite_size)
		filling.set_atlas(FILLING_SHEET)
		filling.region = Rect2(coords[0] * sprite_size,
			coords[1] * sprite_size,
			sprite_size,
			sprite_size)

		bottle.texture = outline
		potion.texture = filling

		if unit.potion:
			potion.visible = true
			potion.modulate = unit.potion.color
		else:
			potion.visible = false
	else:
		bottle.texture = null
		potion.texture = null
