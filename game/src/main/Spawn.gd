extends Node

const MCPS = preload("res://src/Actors/MC.tscn")
var mc


func spawn_player() -> MC:
	if mc:
		remove_child(mc)
	mc = MCPS.instance()
	add_child(mc)
	mc.global_position = self.global_position
	return mc

func _on_dead() -> void:
	spawn_player()
