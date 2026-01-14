class_name SFXConfig
extends Object

enum KEYS {
	GLASS_CLINK,
	GLASS_BREAK,
	UNIT_PLACED,
	SPELL,
	MELEE_HIT,
	RANGED_HIT,
	AOE_HIT,
	GAIN_SHIELD,
	KILN,
	BREWING,
	SHOP_PURCHASE,
	SFX_TEST,
	MUSIC_TEST,
	ARTIFACT_ACTIVATION,
	GAIN_GOLD,
	POTION_FILL,
	TITLE_MUSIC,
	MAIN_MUSIC,
}

const SFX_PATHS := {
	#BATTLE
	KEYS.GLASS_CLINK: "uid://ipc2wt73mu7s",
	KEYS.GLASS_BREAK: "uid://cu0xcpwowafoa",
	KEYS.UNIT_PLACED: "uid://dht20372grp0s",
	KEYS.SPELL: "uid://btwqfit5vwby2",
	KEYS.MELEE_HIT: "uid://c1do5s6xe8b08",
	KEYS.RANGED_HIT: "uid://c706lvxdejdau",
	KEYS.AOE_HIT: "uid://dqx8knkf8bl80",
	KEYS.GAIN_SHIELD: "uid://db33oru7wik6t",
	#ROOMS
	KEYS.KILN: "uid://b2cs7vy1mhquq",
	KEYS.BREWING: "uid://c23i1nuxxo72y",
	KEYS.SHOP_PURCHASE: "uid://doytb5id2b5du",
	#MENU
	KEYS.SFX_TEST: "uid://d51xdv1f4jd6",
	KEYS.MUSIC_TEST: "uid://cu0xcpwowafoa",
	#MISC
	KEYS.ARTIFACT_ACTIVATION: "uid://bxq2fg2l8myli",
	KEYS.GAIN_GOLD: "uid://bbj71s4nu6it0",
	KEYS.POTION_FILL: "uid://dmm4ubyfmihhm",
	#MUSIC
	KEYS.TITLE_MUSIC: "uid://dftkr0hhop7gc",
	KEYS.MAIN_MUSIC: "uid://dgltquu8j218y",
}


static func get_audio_stream(key: KEYS) -> AudioStream:
	return load(SFX_PATHS[key])
