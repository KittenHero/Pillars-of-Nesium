extends Node2D

const MCPS = preload("res://src/Actors/MC.tscn")
var mc

func _ready():
  Globals.set_spawnpoint(self)

#func _ready():
	#Globals.update_spawn(self.global_position)

func spawn_player() -> MC:
	if mc:
		remove_child(mc)
	mc = MCPS.instance()
	add_child(mc)
#	mc.global_position = Globals.spawn_point
	return mc

func _on_dead() -> void:
	spawn_player()
