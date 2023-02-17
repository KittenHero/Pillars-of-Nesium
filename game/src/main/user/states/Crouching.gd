signal push_state
signal pop_state

extends UserState

func physics_process(delta: float):

	if not Input.is_action_pressed("move_down") and _user.can_stand():
		emit_signal("pop_state", "", {})
	elif Input.is_action_just_pressed("slide"):
		emit_signal("pop_state", "", {"slide": true})
	anim_process(delta)

func anim_process(delta: float):
	_user.crouch_look(delta)
	_user.handle_anim_sprite()
	_user.check_anim_player("crouch")

func handle_anim_finished():
	_user.anim_player.stop()

func enter():
	_user.reset_velocity()
	
func exit():
	.exit()
	handle_anim_finished()
