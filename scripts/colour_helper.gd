extends Object
class_name ColourHelper

enum KEYS { DAMAGE, SHIELD, BUFF, DEBUFF }

const colours := {
	KEYS.DAMAGE: Color("#ea3b3b"),
	KEYS.SHIELD: Color("#f9c22b"),
	KEYS.BUFF: Color("#fb6b1d"),
	KEYS.DEBUFF: Color("#165a4c"),
}


static func get_colour(key: KEYS) -> Color:
	return colours.get(key)
