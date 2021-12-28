extends Node

var player1 setget ,_get_player
var gravity = 500
var start = true
var is_game_won = false

func _get_player():
	return player1 if is_instance_valid(player1) else null

func reset():
	start = true
	is_game_won = false
