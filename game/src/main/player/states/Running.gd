extends State

func physics_process(parent: MC, delta: float):
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
		parent.velocity.length_squared() < parent.acc_per_frame() and not is_movement_input):
		parent.pop_state()
	elif Input.is_action_just_pressed("jump"):
		parent.push_state(parent.STATES.AIRBORNE, {"jump": true})
	elif Input.is_action_just_pressed("melee"):
		parent.push_state(parent.STATES.MELEEONE, {"melee": "ground"})
	elif Input.is_action_just_pressed("move_down"):
		parent.push_state(parent.STATES.CROUCHING)
	elif Input.is_action_just_pressed("slide"):
		parent.push_state(parent.STATES.SLIDING, {"slide": true})

func anim_process(parent: MC, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	var current_anim = parent.anim_player.assigned_animation
	if not parent.anim_player.is_playing() or current_anim != "run":
		parent.anim_player.play("run")

func handle_anim_finished(parent: MC):
	parent.anim_player.stop()

func enter(parent: MC):
	# Insant transition
	if "slide" in self._args and self._args["slide"]:
		parent.push_state(parent.STATES.SLIDING, {"slide": true})
	
func exit(parent: MC):
	.exit(parent)
	handle_anim_finished(parent)

