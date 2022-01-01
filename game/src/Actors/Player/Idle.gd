extends "res://src/Actors/State.gd"

func physics_process(parent: KinematicBody2D, delta: float):
	anim_process(parent, delta)
	var grounded = parent.is_on_floor()
	var velocity = parent.apply_gravity(delta)
	
	parent.velocity = parent.move_and_slide(velocity, Vector2.UP)
	
	if grounded and parent.velocity.x != 0:
		parent.apply_stopping_friction(delta)
	if not grounded:
		parent.push_state(parent.STATES.AIRBORNE)

	if Input.is_action_just_pressed("jump"):
		parent.push_state(parent.STATES.AIRBORNE, {"jump": true})
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		parent.push_state(parent.STATES.RUNNING)
	elif Input.is_action_just_pressed("melee"):
		parent.push_state(parent.STATES.MELEEONE, {"melee": "ground"})
	elif Input.is_action_just_pressed("slide"):
		parent.push_state(parent.STATES.SLIDE, {"slide": true})
	
	if parent.velocity.length_squared() < parent.acc_per_frame * parent.acc_per_frame * 2:
		parent.velocity = Vector2.ZERO
	
func anim_process(parent: KinematicBody2D, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	if not parent.anim_player.is_playing():
		parent.anim_player.play("idle")

func handle_anim_finished(parent: KinematicBody2D):
	parent.anim_player.stop()

func enter(parent: KinematicBody2D):
	pass
	
func exit(parent: KinematicBody2D):
	.exit(parent)
	handle_anim_finished(parent)


