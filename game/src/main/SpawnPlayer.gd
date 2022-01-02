extends Node

#const PlayerPS = preload("res://src/main/Player/Player.tscn")
const MCPS = preload("res://src/Actors/MC.tscn")

onready var spawnpoints = $Spawn

func _ready():
	spawn_player()

func spawn_player():
#	var player = PlayerPS.instance()
	var MC = MCPS.instance()
#	entities.add_child(player)
	add_child(MC)
#	player.global_position = spawn.global_position
	MC.global_position = spawnpoints.global_position
	
