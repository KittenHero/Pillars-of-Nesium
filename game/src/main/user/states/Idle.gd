signal push_state
signal pop_state

extends UserState

func physics_process(delta: float):

	var grounded = self._user.is_on_floor()
	
	_user.apply_idle_physics(delta)
	
	if not grounded:
		emit_signal("push_state", "airborne", {})

	if Input.is_action_just_pressed("jump"):
		emit_signal("push_state", "airborne", {"jump": true})
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		emit_signal("push_state", "running", {})
	elif Input.is_action_just_pressed("melee"):
		emit_signal("push_state", "meleeone", {"melee": "ground"})
	elif Input.is_action_just_pressed("slide"):
		emit_signal("push_state", "sliding", {"slide": true})
	elif Input.is_action_just_pressed("move_up") and _user.can_climb():
		emit_signal("push_state", "climbing", {})
	elif Input.is_action_just_pressed("move_down"):
		emit_signal("push_state", "crouching", {})

	anim_process(delta)
	
func anim_process(_delta: float):
	_user.handle_anim_sprite()
	_user.check_anim_player("idle")


func handle_anim_finished():
	_user.stop_anim_player()

func enter():
	# Came from a popped state that needs to transition instantly
	# Ex: Idle -> Climb (pops to Idle) -> Jump
	if "jump" in self._args and self._args["jump"]:
		emit_signal("push_state", "airborne", {"jump": true})
	if "slide" in self._args and self._args["slide"]:
		emit_signal("push_state", "sliding", {"slide": true})
	
func exit():
	.exit()
	handle_anim_finished()
