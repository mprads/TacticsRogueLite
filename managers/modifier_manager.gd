extends Node
class_name ModifierManager

var modifiers: Dictionary[String, Modifier] = {}


func add_modifier(
	source: String,
	type: Modifier.TYPE,
	value_modifier: Modifier.VALUE_MODIFIER,
	value: Variant
) -> void:
	var modifier_instance := Modifier.create_modifier(source, type, value_modifier, value)
	
	modifiers[source] = modifier_instance


func get_modifiers_by_type(type: Modifier.TYPE) -> Array[Modifier]:
	var results: Array[Modifier] = []
	
	for modifier in modifiers.values():
		if modifier.type == type:
			results.append(modifier)
	
	return results
