class_name ModifierManager
extends Node

var modifiers: Dictionary[String, Modifier] = {}


func add_modifier(
	source: String, type: Modifier.TYPE, value_modifier: Modifier.VALUE_MODIFIER, value: Variant
) -> void:
	var modifier_instance := Modifier.create_modifier(source, type, value_modifier, value)

	modifiers[source] = modifier_instance


func remove_modifier(source: String) -> void:
	modifiers.erase(source)


func get_modifier(source: String) -> Modifier:
	return modifiers.get(source)


func increase_modifier_value(source: String, value: float) -> void:
	var modifier = get_modifier(source)

	if not modifier:
		return

	modifier.percent_value += value


func get_modifiers_by_type(type: Modifier.TYPE) -> Array[Modifier]:
	var results: Array[Modifier] = []

	for modifier in modifiers.values():
		if modifier.type == type:
			results.append(modifier)

	return results


func get_modified_value(base: int, type: Modifier.TYPE) -> int:
	var mods = get_modifiers_by_type(type)

	var flat_result := base
	var percent_result := 1.0

	for mod in mods:
		if mod.value_modifier == Modifier.VALUE_MODIFIER.PERCENT:
			percent_result += mod.percent_value

	for mod in mods:
		if mod.value_modifier == Modifier.VALUE_MODIFIER.FLAT:
			flat_result += mod.percent_value

	return floori(flat_result * percent_result)
