extends Control
class_name ResolutionButton

const RESOLUTION_DICTIONARY: Dictionary[String, Vector2i] = {
	"1920X1080": Vector2i(1920, 1080),
	"1280x720": Vector2i(1280, 720),
	"640x360": Vector2i(640, 360),
}

@onready var option_button: OptionButton = %OptionButton


func _ready() -> void:
	option_button.item_selected.connect(_on_item_selected)
	add_window_mode_items()


func add_window_mode_items() -> void:
	for option in RESOLUTION_DICTIONARY:
		option_button.add_item(option)


func _on_item_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
