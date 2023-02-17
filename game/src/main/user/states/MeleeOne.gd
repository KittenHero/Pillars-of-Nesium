signal pop_state
signal push_state

extends UserState

func physics_process(delta: float):
	if not "melee" in self._args:
		return emit_signal("pop_state", "", {})

	match self._args["melee"]:
		"ground":
			_user.reset_velocity()
			if Input.is_action_just_pressed("melee") and _user.anim_player.is_playing():
				self._args["next"] = "meleetwo"
				self._args["next_args"] = {"melee": "ground"}
		"air":
			_user.apply_airborne(delta)
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
			_user.play_anim_player("melee_one")
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
	if anim_name == "melee_one":
		self._args["completed"] = true
