signal push_state
signal pop_state

extends UserState

var anim_direction := Vector2.RIGHT

func physics_process(delta: float):
	_user.climb(delta)
	_user.apply_climbing_physics(delta)

	if Input.is_action_just_pressed("jump"):
		emit_signal("pop_state", "", {"jump": "true"})
	anim_process(delta)

func anim_process(delta: float):
	_user.handle_climbing_anim(delta)


func handle_anim_finished():
	_user.stop_anim_player()


func enter():
	if "climb" in self._args and self._args["climb"]:
		_user.reset_velocity()
	else:
		emit_signal("pop_state", "", {})

func exit():
	_user.reset_velocity()
	.exit() 
	handle_anim_finished()
