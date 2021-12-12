extends "res://src/Actors/State.gd"

func physics_process(parent: KinematicBody2D, _delta: float):
	if not parent.is_on_floor():
		parent.push_state(parent.STATES.FALLING)
	elif Input.is_action_just_pressed("jump"):
		parent.push_state(parent.STATES.JUMPING, {"jump": true})
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		parent.push_state(parent.STATES.RUNNING)
	elif Input.is_action_just_pressed("melee"):
		print("called from idle")
		parent.push_state(parent.STATES.MELEEONE, {"melee": "ground"})
	
func enter(parent: KinematicBody2D):
	if parent.is_on_floor():
		parent.velocity = Vector2.ZERO
	
func exit(parent: KinematicBody2D):
	.exit(parent)
