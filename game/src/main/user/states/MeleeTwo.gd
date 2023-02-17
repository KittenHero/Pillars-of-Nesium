signal push_state
signal pop_state

extends UserState

func physics_process(delta: float):
	if not "melee" in self._args:
		emit_signal("pop_state", "", {})
	anim_process(delta)
	if "completed" in self._args and self._args["completed"]:
		if "next" in self._args and "next_args":
			emit_signal("push_state", self._args.get("next"), self._args.get("next_args"))
		else:
			emit_signal("pop_state", "", {})
	
func anim_process(_delta: float):
	_user.handle_anim_sprite()
	match self._args["melee"]:
		"ground":
			_user.play_anim_player("melee_two")
		"air":
			_user.play_anim_player("air_melee")

func handle_anim_finished():
	_user.stop_anim_player()

	
func enter():
	_user.stop_anim_player()
	self._args["completed"] = false
	
func exit():
	.exit()
	handle_anim_finished()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "melee_two":
		self._args["completed"] = true
