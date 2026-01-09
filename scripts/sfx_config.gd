class_name SFXConfig
extends Object

enum KEYS {
	GAIN_GOLD,
	POTION_FILL,
	#BATTLE
	GLASS_BREAK,
	GLASS_CLINK,
	UNIT_PLACED,
	SPELL,
	MELEE_HIT,
	RANGED_HIT,
	AOE_HIT,
	GAIN_SHIELD,
	#ROOMS
	KILN,
	BREWING,
	SHOP_PURCHASE,
}

const SFX_PATHS := {
	KEYS.GAIN_GOLD: "uid://bbj71s4nu6it0",
	KEYS.POTION_FILL: "uid://dmm4ubyfmihhm",
	#BATTLE
	KEYS.GLASS_BREAK: "uid://cu0xcpwowafoa",
	KEYS.GLASS_CLINK: "uid://ipc2wt73mu7s",
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
}


static func get_audio_stream(key: KEYS) -> AudioStream:
	return load(SFX_PATHS[key])
