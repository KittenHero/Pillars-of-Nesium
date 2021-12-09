extends "res://src/Actors/State.gd"

func physics_process(parent: KinematicBody2D, delta: float):
	# TODO: just add melee two and three in the match expressions
	# might be good to allow for this if we add more powerups, they ll have m1 only
	if not "melee" in _args:
		return parent.pop_state()
	match _args["melee"]:
		"ground":
			parent.velocity = Vector2.ZERO
			print("Ground melee attack, put animation here")
			if Input.is_action_pressed("melee"):
				parent.push_state(parent.STATES.MELEETWO, {"melee": "ground"})
		"air":
			var velocity = parent.move_horizontal(delta)
			# TODO: extract as function and move to move_vertical
			velocity.y += parent.gravity * delta
			parent.velocity = parent.move_and_slide(velocity, Vector2.UP)
			print("Air melee attack, put animation here")
			parent.pop_state()
	
func enter(_parent: KinematicBody2D):
	pass
	
func exit(parent: KinematicBody2D):
	.exit(parent)

