signal push_state
signal pop_state

extends UserState

func physics_process(delta: float):
	_user.apply_running_physics(delta)
	
	if not _user.is_on_floor() or _user.is_too_slow():
		emit_signal("pop_state", "", {})
	elif Input.is_action_just_pressed("jump"):
		emit_signal("push_state", "airborne", {"jump": true})
	elif Input.is_action_just_pressed("melee"):
		emit_signal("push_state","meleeone", {"melee": "ground"})
	elif Input.is_action_just_pressed("move_down"):
		emit_signal("push_state","crouching", {})
	elif Input.is_action_just_pressed("slide"):
		emit_signal("push_state","sliding", {"slide": true})
	anim_process(delta)

func anim_process(_delta: float):
	_user.handle_anim_sprite()
	_user.check_anim_player("run")

func handle_anim_finished():
	_user.stop_anim_player()

func enter():
	# Insant transition
	if "slide" in self._args and self._args["slide"]:
		emit_signal("push_state","sliding", {"slide": true})
	
func exit():
	.exit()
	handle_anim_finished()
