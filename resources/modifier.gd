extends RefCounted
class_name Modifier

enum TYPE { DAMAGE_DEALT, DAMAGE_TAKEN }
enum VALUE_MODIFIER { PERCENT, FLAT }

var type: TYPE
var value_modifier: VALUE_MODIFIER
var source: String
var flat_value := 0
var percent_value := 0.0


static func create_modifier(
	modifier_source: String,
	modifier_type: TYPE,
	value_type: VALUE_MODIFIER,
	value: Variant
) -> Modifier:
	var modifier_instance := new()
	modifier_instance.source = modifier_source
	modifier_instance.type = modifier_type
	
	if value_type == VALUE_MODIFIER.PERCENT:
		modifier_instance.percent_value = value
	elif value_type == VALUE_MODIFIER.FLAT:
		modifier_instance.flat_value = value

	return modifier_instance
