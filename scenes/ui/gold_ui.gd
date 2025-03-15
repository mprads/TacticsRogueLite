extends HBoxContainer
class_name GoldUI

@export var run_stats: RunStats : set = _set_run_stats

@onready var label: Label = $Label

var tween: Tween

func _ready() -> void:
	label.text = "0"
	

func _set_run_stats(value: RunStats) -> void:
	run_stats = value
	
	if not run_stats.gold_changed.is_connected(_update_gold):
		run_stats.gold_changed.connect(_update_gold)
		_update_gold()
		

func _update_gold() -> void:
	if tween:
		tween.kill()
	else: 
		tween = create_tween()
	
	tween.tween_property(label, "text", str(run_stats.gold), .5)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
