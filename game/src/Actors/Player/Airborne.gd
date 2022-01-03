extends "res://src/Actors/State.gd"

func handle_normal(parent: MC, delta: float) -> Vector2:
#	Need air melee sprite to uncomment this
#	if Input.is_action_just_pressed("melee"):
#		parent.push_state(parent.STATES.MELEEONE, {"melee": "air"})
#	elif parent.is_on_floor():
#		parent.pop_state()
	if Input.is_action_just_released("jump"):
		if parent.velocity.y < parent.terminal_velocity:
			parent.velocity.y = parent.terminal_velocity
	var velocity = parent.move_air_horizontal(delta)
	velocity = parent.apply_gravity(delta)
	return velocity

func handle_slide_jump(parent: MC, delta: float) -> Vector2:
	var velocity = parent.move_air_horizontal(delta, 
		parent.max_speed*parent.slide_speed_multiplier)
	velocity = parent.apply_gravity(delta, parent.slide_gravity_multiplier)
	return velocity

func physics_process(parent: MC, delta: float):
	anim_process(parent, delta)
	var velocity
	if "slide_jump" in _args:
		velocity = handle_slide_jump(parent, delta)
	else:	
		velocity = handle_normal(parent, delta)
	parent.velocity = parent.move_and_slide(velocity, Vector2.UP)
	if parent.is_on_floor():
		parent.pop_state()
	if Input.is_action_just_pressed("move_up") and parent.can_climb():
		parent.push_state(parent.STATES.CLIMBING, {"climb": "true"})

func anim_process(parent: MC, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	if parent.velocity.y >= 0:
		parent.anim_player.play("fall")
	elif parent.velocity.y <= 0:
		parent.anim_player.play("jump")

func handle_anim_finished(parent: MC):
	parent.anim_player.stop()

func enter(parent: MC):
	if "jump" in _args and _args["jump"]:
		# Instant release
		if not Input.is_action_pressed("jump"):
			parent.velocity.y = parent.terminal_velocity
		else:
			parent.velocity.y = parent.init_jump_velocity
	elif "slide_jump" in _args and _args["slide_jump"]:
		parent.velocity.y = parent.slide_jump_velocity
	
func exit(parent: MC):
	.exit(parent) 
	handle_anim_finished(parent)
