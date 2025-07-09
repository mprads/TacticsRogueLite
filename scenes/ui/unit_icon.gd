class_name UnitIcon
extends Control

const FILLING_SHEET = preload("res://assets/sprites/potions/filling_sheet.png")
const OUTLINE_SHEET = preload("res://assets/sprites/potions/outline_sheet.png")

@export var unit_stats: UnitStats:
	set = set_unit_stats

@onready var bottle: TextureRect = %Bottle
@onready var potion_fill_progress: TextureProgressBar = %PotionFillProgress


func set_unit_stats(value: UnitStats) -> void:
	unit_stats = value

	_set_visuals()


func _set_visuals() -> void:
	if unit_stats:
		var coords = unit_stats.bottle.sprite_coordinates
		var sprite_size = unit_stats.bottle.sprite_size

		var outline = AtlasTexture.new()
		var filling = AtlasTexture.new()
		outline.set_atlas(OUTLINE_SHEET)
		outline.region = Rect2(
			coords[0] * sprite_size, coords[1] * sprite_size, sprite_size, sprite_size
		)
		filling.set_atlas(FILLING_SHEET)
		filling.region = Rect2(
			coords[0] * sprite_size, coords[1] * sprite_size, sprite_size, sprite_size
		)

		bottle.texture = outline

		if unit_stats.potion:
			potion_fill_progress.texture_progress = filling
			potion_fill_progress.modulate = unit_stats.potion.color
			potion_fill_progress.max_value = unit_stats.max_oz
			potion_fill_progress.value = unit_stats.oz
		else:
			potion_fill_progress.value = 0
	else:
		bottle.texture = null
