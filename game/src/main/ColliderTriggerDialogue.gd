extends Node

var current = 0
onready var num_lines = get_child_count()

func _on_ColliderTriggerDialogue_area_entered(area: Area2D) -> void:
	var delay = 0
	if current > 0:
		var last_line = get_child(current-1)
		last_line.unsay(0)
		delay = last_line.bg_delay
		
	if current < num_lines:
		get_child(current).say(delay)
		current += 1
	else:
		current = 0
