extends PlayerState

func physics_process(parent: MC, delta: float):

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
		parent.push_state(parent.STATES.SLIDING, {"slide": true})
	elif Input.is_action_just_pressed("move_up") and parent.can_climb():
		parent.push_state(parent.STATES.CLIMBING)
	elif Input.is_action_just_pressed("move_down"):
		parent.push_state(parent.STATES.CROUCHING)

	if parent.velocity.length_squared() < parent.acc_per_frame * parent.acc_per_frame * 2:
		parent.velocity = Vector2.ZERO
	anim_process(parent, delta)
	
func anim_process(parent: MC, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	var current_anim = parent.anim_player.assigned_animation
	if not parent.anim_player.is_playing() or current_anim != "idle":
		parent.anim_player.play("idle")

func handle_anim_finished(parent: MC):
	parent.anim_player.stop()

func enter(parent: MC):
	# Came from a popped state that needs to transition instantly
	# Ex: Idle -> Climb (pops to Idle) -> Jump
	if "jump" in self._args and self._args["jump"]:
		parent.push_state(parent.STATES.AIRBORNE, {"jump": true})
	if "slide" in self._args and self._args["slide"]:
		parent.push_state(parent.STATES.SLIDING, {"slide": true})
	
func exit(parent: MC):
	.exit(parent)
	handle_anim_finished(parent)


