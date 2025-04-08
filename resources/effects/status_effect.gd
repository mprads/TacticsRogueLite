extends Effect
class_name StatusEffect

var status: Status


func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target: continue
		
		if target is Enemy or target is Unit:
			target.add_status(status)
