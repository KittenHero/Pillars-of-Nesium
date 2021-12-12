extends "res://src/Actors/State.gd"
	

func physics_process(parent: KinematicBody2D, delta: float):
	print("falling", parent.velocity)
	parent.velocity.y += parent.gravity * delta
	parent.velocity = parent.move_and_slide(
		parent.move_horizontal(delta), Vector2.UP
	)
	
	if parent.is_on_floor():
		parent.pop_state()
	elif Input.is_action_just_pressed("melee"):
		parent.push_state(parent.STATES.MELEEONE, {"melee": "air"})
	
func enter(_parent: KinematicBody2D):
	pass
	
func exit(parent: KinematicBody2D):
	.exit(parent)
