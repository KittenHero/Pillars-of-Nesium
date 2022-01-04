<<<<<<< HEAD
extends Node
=======
extends Node2D
>>>>>>> origin/Jacob

const MCPS = preload("res://src/Actors/MC.tscn")
var mc

<<<<<<< HEAD
=======
func _ready():
  Globals.set_spawnpoint(self)

#func _ready():
	#Globals.update_spawn(self.global_position)
>>>>>>> origin/Jacob

func spawn_player() -> MC:
	if mc:
		remove_child(mc)
	mc = MCPS.instance()
	add_child(mc)
<<<<<<< HEAD
	mc.global_position = self.global_position
=======
#	mc.global_position = Globals.spawn_point
>>>>>>> origin/Jacob
	return mc

func _on_dead() -> void:
	spawn_player()
