extends "res://src/Actors/State.gd"

func physics_process(parent: KinematicBody2D, delta: float):
	var velocity = parent.move_horizontal(delta)
	parent.velocity = parent.move_and_slide_with_snap(
		velocity, Vector2(0, 2 * velocity.abs().x * delta), Vector2.UP
	)
	
	if not parent.is_on_floor() or parent.velocity.length_squared() < parent.acc_per_frame:
		parent.pop_state()
	elif Input.is_action_just_pressed("jump"):
		parent.push_state(parent.STATES.JUMPING, {"jump": true})
	elif Input.is_action_just_pressed("melee"):
		parent.push_state(parent.STATES.MELEEONE, {"melee": "ground"})

func enter(_parent: KinematicBody2D):
	pass
	
func exit(parent: KinematicBody2D):
	.exit(parent)
