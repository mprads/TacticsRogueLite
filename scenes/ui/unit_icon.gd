class_name UnitIcon
extends Control

@export var unit_stats: UnitStats:
	set = set_unit_stats

@onready var bottle: TextureRect = %Bottle
@onready var filling: TextureRect = %Filling
@onready var damage: TextureRect = %Damage


func set_unit_stats(value: UnitStats) -> void:
	if not is_node_ready():
		await ready

	unit_stats = value

	if not value.changed.is_connected(_update_visuals):
		value.changed.connect(_update_visuals)

	if value == null:
		return

	_update_visuals()


func _update_visuals() -> void:
	if not unit_stats:
		return

	bottle.texture = unit_stats.bottle.bottle_sprite
	filling.texture = unit_stats.bottle.liquid_mask
	damage.texture = unit_stats.bottle.liquid_mask

	damage.material.set_shader_parameter("noise_seed", RNG.instance.randf_range(0.0, 999.0))
	# Shader sensitivity uses range between 0.0 and 1.0 but anything past .5 is too noisy
	var damage_percent = (1 - (float(unit_stats.health) / float(unit_stats.max_health))) * .5
	damage.material.set_shader_parameter("sensitivity", damage_percent)

	if unit_stats.potion:
		filling.visible = true
		filling.material.set_shader_parameter("Mask", unit_stats.bottle.liquid_mask)
		filling.material.set_shader_parameter("Color", unit_stats.potion.color)
		filling.material.set_shader_parameter("Fill", float(unit_stats.oz) / float(unit_stats.bottle.max_oz))
	else:
		filling.visible = false
