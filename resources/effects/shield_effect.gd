extends Effect
class_name ShieldEffect

var amount := 0


func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target: continue
		
		if target is Enemy or target is Unit:
			target.stats.shield += amount
