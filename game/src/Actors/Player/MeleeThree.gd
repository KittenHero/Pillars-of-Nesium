extends "res://src/Actors/State.gd"

func physics_process(parent: KinematicBody2D, _delta: float):
	if not "melee" in _args:
		return parent.pop_state()
	match _args["melee"]:
		"ground":
			# Came from second melee, not popped out with 0 args
			print("Third melee attack, put animation here")
	parent.pop_state()
	
func enter(parent: KinematicBody2D):
	pass
	
func exit(parent: KinematicBody2D):
	.exit(parent)
