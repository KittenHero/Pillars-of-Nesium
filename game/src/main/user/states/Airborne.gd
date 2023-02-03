signal push_state
signal pop_state

extends UserState

func handle_normal(delta: float) -> void:
#	Need air melee sprite to uncomment this
#	if Input.is_action_just_pressed("melee"):
#		parent.push_state(parent.STATES.MELEEONE, {"melee": "air"})
#	elif parent.is_on_floor():
#		parent.pop_state()
	_user.apply_normal_jump(delta)


func physics_process(delta: float):
	if "slide_jump" in self._args:
		_user.apply_slide_jump(delta)
	else:
		handle_normal(delta)
	_user.apply_airborne_physics(delta)

	if _user.is_on_floor():
		emit_signal("pop_state", "", {})
	if Input.is_action_just_pressed("climb") and _user.can_climb():
		emit_signal("push_state", "climbing", {"climb": "true"})
	
	anim_process(delta)

func anim_process(_delta: float):
	_user.handle_anim_sprite()
	_user.check_anim_player_fall_jump()


func handle_anim_finished():
	_user.stop_anim_player()

func enter():
	if "jump" in self._args and self._args["jump"]:
		# Instant release
		if not Input.is_action_pressed("jump"):
			_user.apply_terminal_velocity()
		else:
			_user.apply_jump_velocity()

	elif "slide_jump" in self._args and self._args["slide_jump"]:
		_user.apply_slide_jump_velocity()
	
func exit():
	.exit() 
	handle_anim_finished()
