extends "res://src/Actors/State.gd"

func physics_process(parent: KinematicBody2D, delta: float):
	anim_process(parent, delta)
#	Need air melee sprite to uncomment this
#	if Input.is_action_just_pressed("melee"):
#		parent.push_state(parent.STATES.MELEEONE, {"melee": "air"})
#	elif parent.is_on_floor():
#		parent.pop_state()
	if parent.is_on_floor():
		parent.pop_state()
	var velocity = parent.move_horizontal(delta)
	velocity = parent.apply_gravity(delta)
	parent.velocity = parent.move_and_slide(velocity, Vector2.UP)

func anim_process(parent: KinematicBody2D, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	if parent.velocity.y >= 0:
		parent.anim_player.play("fall")
	elif parent.velocity.y <= 0:
		parent.anim_player.play("jump")

func handle_anim_finished(parent: KinematicBody2D):
	parent.anim_player.stop()

func enter(parent: KinematicBody2D):
	if "jump" in _args and _args["jump"]:
		parent.velocity.y = - sqrt(2 * parent.jump_height * parent.gravity)
	
func exit(parent: KinematicBody2D):
	.exit(parent) 
	handle_anim_finished(parent)
