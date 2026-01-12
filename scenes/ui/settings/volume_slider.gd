extends VBoxContainer

@export var bus_name: String
@export var test_sound: SFXConfig.KEYS

@onready var h_slider: HSlider = $HSlider
@onready var label: Label = $Label

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	h_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)

	h_slider.value_changed.connect(_on_value_changed)

	label.text = "%s Volume" % bus_name

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

	if bus_index == 1:
		SFXPlayer.play(SFXConfig.get_audio_stream(test_sound), true)
	elif bus_index == 2:
		MusicPlayer.play(SFXConfig.get_audio_stream(test_sound), true)
