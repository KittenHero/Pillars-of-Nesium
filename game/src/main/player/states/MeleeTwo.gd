extends State

func physics_process(parent: MC, delta: float):
	if not "melee" in self._args:
		return parent.pop_state()
	anim_process(parent, delta)
	if "completed" in self._args and self._args["completed"]:
		if "next" in self._args and "next_args":
			parent.push_state(self._args.get("next"), self._args.get("next_args"))
		else:
			parent.pop_state()
	
func anim_process(parent: MC, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	match self._args["melee"]:
		"ground":
			parent.anim_player.play("melee_two")
		"air":
			parent.anim_player.play("air_melee")

func handle_anim_finished(parent: MC):
	parent.anim_player.stop()
	
func enter(parent: MC):
	if parent.anim_player.is_playing():
		parent.anim_player.stop()
	self._args["completed"] = false
	
func exit(parent: MC):
	.exit(parent)
	handle_anim_finished(parent)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "melee_two":
		self._args["completed"] = true
