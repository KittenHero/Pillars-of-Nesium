extends Node

var player setget ,_get_player
var MC setget ,_get_MC
var gravity = 500
var start = true
var is_game_won = false
var spawn_point
var spawn: Node2D
func set_spawnpoint(spawnpoint: Node2D):
   spawn = spawnpoint

func update_spawnpoint(location: Vector2):
   spawn.global_position = location

func _get_player():
	return player if is_instance_valid(player) else null
	
func _get_MC():
	return MC if is_instance_valid(player) else null

#func update_spawn(new_point):
#	spawn_point = new_point

func reset():
	start = true
	is_game_won = false
