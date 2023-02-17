signal pop_state
signal push_state

extends UserState

var active: bool

func physics_process(delta: float):
	_user.apply_sliding_physics(delta)
	if not _user.is_on_floor():
		emit_signal('push_state', "airborne", {"slide_jump": false})
	elif _user.has_completed_slide(self._args["initial"]):
			if _user.can_stand() and not Input.is_action_pressed("move_down"):
				emit_signal("pop_state", "", {})
			else:
				emit_signal("push_state", "crouching", {})
	if Input.is_action_just_pressed("jump") and _user.can_stand() and _user.is_on_floor():
		emit_signal("push_state", "airborne", {"slide_jump": true})
	anim_process(delta)

func anim_process(_delta: float):
	_user.handle_anim_sprite()
	if active:
		_user.rotate_anim_sprite()
	else:
		_user.reset_anim_sprite_rotation()
	_user.check_anim_player("slide")

func handle_anim_finished():
	_user.stop_anim_player()

func enter():
	active = true
	if not "slide" in self._args:
		emit_signal("pop_state", "", {})
	self._args["initial"] = _user.frame_count
	
func exit():
	.exit()
	active = false
	handle_anim_finished()
