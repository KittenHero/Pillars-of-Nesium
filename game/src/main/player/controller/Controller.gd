tool

extends Node

class_name SetupMC

export var starting_stats : Resource

onready var stats = $StatsMC

func _ready():
	stats.initialize(starting_stats) 
