extends "res://src/Actors/State.gd"

func physics_process(parent: KinematicBody2D, delta: float):
	var velocity = parent.move_horizontal(delta)
	velocity.y += parent.gravity * delta
	parent.velocity = parent.move_and_slide(velocity, Vector2.UP)
	
	if parent.velocity.y >= 0:
		parent.pop_state()
	elif Input.is_action_just_pressed("melee"):
		parent.push_state(parent.STATES.MELEEONE, {"melee": "air"})
	
func enter(parent: KinematicBody2D):
	parent.velocity.y = - sqrt(2 * parent.jump_height * parent.gravity)
	
func exit(parent: KinematicBody2D):
	.exit(parent)
