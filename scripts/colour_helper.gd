class_name ColourHelper
extends Object

enum KEYS { DAMAGE, SHIELD, BUFF, DEBUFF, WHITE, BLACK, CURSE }

const COLOURS := {
	KEYS.WHITE: Color("#EAFAF7"),
	KEYS.BLACK: Color("#051512"),
	KEYS.DAMAGE: Color("#ea3b3b"),
	KEYS.SHIELD: Color("#f9c22b"),
	KEYS.BUFF: Color("#fb6b1d"),
	KEYS.DEBUFF: Color("#165a4c"),
	KEYS.CURSE: Color("#6b3e75"),
}


static func get_colour(key: KEYS) -> Color:
	return COLOURS.get(key)
