extends "res://src/Actors/State.gd"

func physics_process(parent: KinematicBody2D, delta: float):
	if parent.velocity.y >= 0 or not _args["jump"]:
		parent.pop_state()
	elif Input.is_action_just_pressed("melee"):
		parent.push_state(parent.STATES.MELEEONE, {"melee": "air"})
	
	var velocity = parent.move_horizontal(delta)
	print(parent.velocity)
	velocity.y += parent.gravity * delta
	parent.velocity = parent.move_and_slide(velocity, Vector2.UP)
	

	
func enter(parent: KinematicBody2D):
	if not _args["jump"]:
		return
	parent.velocity.y = - sqrt(2 * parent.jump_height * parent.gravity)
	# BUGFIX: Add air friction so it is reduced in the same frame
	# is_on_floor returning true for first frame
	parent.velocity.x += parent.velocity.sign().x * parent.acc_per_frame;
	
func exit(parent: KinematicBody2D):
	.exit(parent)
