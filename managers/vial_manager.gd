class_name VialManager
extends Node

signal vials_changed

@export var run_stats: RunStats:
	set = set_run_stats

@export var ui_layer: CanvasLayer


func _ready() -> void:
	Events.change_max_vial_count.connect(_on_change_max_vial_count)


func get_vials() -> Array[Vial]:
	return run_stats.vials


func add_vial(vial: Vial) -> void:
	if run_stats.vials.size() == run_stats.max_vial_count:
		for existing_vial in run_stats.vials:
			if not existing_vial.potion:
				existing_vial.potion = vial.potion
	else:
		run_stats.vials.append(vial)

	vials_changed.emit()


func remove_vial(vial: Vial) -> void:
	if not vial:
		return

	if not run_stats.vials.has(vial):
		return

	run_stats.vials.erase(vial)
	vials_changed.emit()


func set_run_stats(value: RunStats) -> void:
	run_stats = value

	if not run_stats:
		return

	for vial in run_stats.vials:
		vial.changed.connect(vials_changed.emit)


func _on_change_max_vial_count(amount: int) -> void:
	var previous_max = run_stats.max_vial_count
	run_stats.max_vial_count += amount

	if previous_max < run_stats.max_vial_count:
		add_vial(Vial.new())

	if previous_max > run_stats.max_vial_count:
		if run_stats.max_vial_count < run_stats.vials.size():
			var discard_vial_ui := DiscardVialUI.create_new(self, false)
			discard_vial_ui.vial_selected.connect(_on_vial_selected)
			ui_layer.add_child(discard_vial_ui)


func _on_vial_selected(vial: Vial) -> void:
	remove_vial(vial)
