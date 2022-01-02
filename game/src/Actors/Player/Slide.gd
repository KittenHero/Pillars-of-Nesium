extends State

func physics_process(parent: KinematicBody2D, delta: float):
	var velocity = parent.slide(delta)
	velocity = parent.apply_gravity(delta)
	parent.velocity = parent.move_and_slide_with_snap(
		velocity, Vector2(0, 2 * velocity.abs().x * delta), Vector2.UP
	)
	if parent.frame_count - _args["initial"] > parent.slide_duration:
		parent.pop_state()
	if Input.is_action_just_pressed("jump"):
		parent.push_state(parent.STATES.AIRBORNE, {"slide_jump": true})
	anim_process(parent, delta)

func anim_process(parent: KinematicBody2D, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	var current_anim = parent.anim_player.assigned_animation
	if not parent.anim_player.is_playing() or current_anim != "slide":
		parent.anim_player.play("slide")

func handle_anim_finished(parent: KinematicBody2D):
	parent.anim_player.stop()

func enter(parent: KinematicBody2D):
	if not "slide" in _args:
		parent.pop_state()
	_args["initial"] = parent.frame_count
	
func exit(parent: KinematicBody2D):
	.exit(parent)
	handle_anim_finished(parent)
