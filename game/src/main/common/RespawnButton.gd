extends Node

const speechps = preload("res://src/main/common/dialogue/SpeechBubble.tscn")
export var font: Resource = preload("res://assets/fonts/Kenney Future.ttf")
onready var spawner = self.get_parent()

func _ready() -> void:
	var event = InputMap.get_action_list("respawn")[0]
	var key = OS.get_scancode_string(event.get_physical_scancode_with_modifiers())
	var speech = speechps.instance()
	speech.text = "Press %s to respawn" % key
	speech.delay = 0
	speech.font_resource = font
	speech.read_delay = INF
	add_child(speech)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("respawn"):
		spawner.mc.kill()
