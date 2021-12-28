extends Node

#const PlayerPS = preload("res://src/main/Player/Player.tscn")
const MCPS = preload("res://src/Actors/MC.tscn")

onready var player_health_bar = $UI/Interface/HealthDisplay
onready var entities = $Entities
onready var spawnpoints = $Spawn

func _ready():
	spawn_player(0)
	
func spawn_player(id: int):
	var spawn = spawnpoints.get_child(id)
#	var player = PlayerPS.instance()
	var MC = MCPS.instance()
#	entities.add_child(player)
	entities.add_child(MC)
#	player.global_position = spawn.global_position
	MC.global_position = spawn.global_position
	
