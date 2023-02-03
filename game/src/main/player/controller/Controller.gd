tool

extends Node

class_name SetupMC

export var starting_stats : Resource

onready var stats = $Stats
onready var physics = $Physics

func _ready():
	stats.initialize(starting_stats) 

func get_physics() -> Physics:
	return $Physics.get_script()
