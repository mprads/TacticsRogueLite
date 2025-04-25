extends Control
class_name  WindowModeButton

const WINDOW_MODE_ARRAY: Array[String] = [
	"Windowed Borderless",
	"Windowed",
	"Fullscreen Borderless",
	"Fullscreen",
]

@onready var option_button: OptionButton = %OptionButton


func _ready() -> void:
	option_button.item_selected.connect(_on_item_selected)
	add_window_mode_items()


func add_window_mode_items() -> void:
	for option in WINDOW_MODE_ARRAY:
		option_button.add_item(option)


func _on_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


#const WINDOW_MODE_ARRAY: Array[String] = [
	#"640x360",
	#"1289x720",
	#"1920X1080",
#]
