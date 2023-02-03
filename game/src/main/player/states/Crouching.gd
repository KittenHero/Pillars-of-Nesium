extends PlayerState

func physics_process(parent: MC, delta: float):
	parent.crouch_look(delta)
	if not Input.is_action_pressed("move_down") and parent.can_stand():
		parent.pop_state()
	elif Input.is_action_just_pressed("slide"):
		parent.pop_state({"slide": true})
	anim_process(parent, delta)

func anim_process(parent: MC, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	var current_anim = parent.anim_player.assigned_animation
	if not parent.anim_player.is_playing() or current_anim != "crouch":
		parent.anim_player.play("crouch")

func handle_anim_finished(parent: MC):
	parent.anim_player.stop()

func enter(parent: MC):
	parent.velocity = Vector2.ZERO
	
func exit(parent: MC):
	.exit(parent)
	handle_anim_finished(parent)
