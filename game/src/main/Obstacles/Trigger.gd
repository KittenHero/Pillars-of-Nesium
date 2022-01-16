extends Area2D

signal trigger

onready var traps = self.get_node("Traps").get_children()

func _ready() -> void:
	for trap in traps:
		print(trap)
		connect("trigger", trap, "_on_trap_triggered")

func _on_Trigger_body_entered(body: Node) -> void:
	emit_signal("trigger")
