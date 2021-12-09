extends "res://src/Actors/State.gd"

func physics_process(parent: KinematicBody2D, _delta: float):
	if not "melee" in _args:
		return parent.pop_state()
	match _args["melee"]:
		"ground":
			# Came from first melee, not popped out with 0 args
			print("Second melee attack, put animation here")
			if Input.is_action_pressed("melee"):
				parent.push_state(parent.STATES.MELEETHREE, {"melee": "ground"})
	
func enter(parent: KinematicBody2D):
	pass
	
func exit(parent: KinematicBody2D):
	.exit(parent)
