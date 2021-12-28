extends "res://src/Actors/State.gd"

func physics_process(parent: KinematicBody2D, delta: float):
	var is_movement_input = (Input.is_action_pressed("move_left") 
		or Input.is_action_pressed("move_right"))
	anim_process(parent, delta)
	var velocity = parent.move_horizontal(delta)
	if not is_movement_input:
		velocity = parent.apply_stopping_friction(delta)
	parent.velocity = parent.move_and_slide_with_snap(
		velocity, Vector2(0, 2 * velocity.abs().x * delta), Vector2.UP
	)
	
	if not parent.is_on_floor() or (
		parent.velocity.length_squared() < parent.acc_per_frame and not is_movement_input):
		parent.pop_state()
	elif Input.is_action_just_pressed("jump"):
		parent.push_state(parent.STATES.AIRBORNE, {"jump": true})
	elif Input.is_action_just_pressed("melee"):
		parent.push_state(parent.STATES.MELEEONE, {"melee": "ground"})

func anim_process(parent: KinematicBody2D, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	if not parent.anim_player.is_playing():
		parent.anim_player.play("run")

func handle_anim_finished(parent: KinematicBody2D):
	parent.anim_player.stop()

func enter(_parent: KinematicBody2D):
	pass
	
func exit(parent: KinematicBody2D):
	.exit(parent)
	handle_anim_finished(parent)

