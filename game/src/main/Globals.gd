extends Node

var player setget ,_get_player
var MC setget ,_get_MC
var gravity = 500
var start = true
var is_game_won = false

func _get_player():
	return player if is_instance_valid(player) else null
	
func _get_MC():
	return MC if is_instance_valid(player) else null

func reset():
	start = true
	is_game_won = false
