extends Node2D


func _ready(delta):
	if player.position.distance_to(Vector2(80, 80)) < 10:
		var force = Vector2(0, 100)
		player.sink(force * delta) with function body.

