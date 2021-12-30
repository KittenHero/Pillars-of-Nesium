extends State

func physics_process(parent: KinematicBody2D, delta: float):
	if not "slide" in _args and not _args["slide"]:
		parent.pop_state()
	anim_process(parent, delta)
	var velocity = parent.slide(delta)
	velocity = parent.apply_gravity(delta)
	parent.velocity = parent.move_and_slide_with_snap(
		velocity, Vector2(0, 2 * velocity.abs().x * delta), Vector2.UP
	)
	if parent.frame_count - _args["initial"] > parent.slide_duration:
		parent.pop_state()

func anim_process(parent: KinematicBody2D, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	if not parent.anim_player.is_playing():
		parent.anim_player.play("slide")

func handle_anim_finished(parent: KinematicBody2D):
	parent.anim_player.stop()

func enter(parent: KinematicBody2D):
	_args["initial"] = parent.frame_count
	
func exit(parent: KinematicBody2D):
	.exit(parent)
	handle_anim_finished(parent)
