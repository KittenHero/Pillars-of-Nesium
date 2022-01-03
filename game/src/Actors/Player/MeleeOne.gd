extends "res://src/Actors/State.gd"

func physics_process(parent: MC, delta: float):
	if not "melee" in _args:
		return parent.pop_state()

	match _args["melee"]:
		"ground":
			parent.velocity = Vector2.ZERO
			if Input.is_action_just_pressed("melee") and parent.anim_player.is_playing():
				_args["next"] = parent.STATES.MELEETWO
				_args["next_args"] = {"melee": "ground"}
		"air":
			var velocity = parent.move_air_horizontal(delta)
			parent.apply_gravity(delta)
			parent.velocity = parent.move_and_slide(velocity, Vector2.UP)
	anim_process(parent, delta)
	if "completed" in _args and _args["completed"]:
		if "next" in _args and "next_args":
			parent.push_state(_args.get("next"), _args.get("next_args"))
		else:
			parent.pop_state()

func anim_process(parent: MC, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	match _args["melee"]:
		"ground":
			parent.anim_player.play("melee_one")
		"air":
			parent.anim_player.play("air_melee")

func handle_anim_finished(parent: MC):
	parent.anim_player.stop()
	
func enter(parent: MC):
	if parent.anim_player.is_playing():
		parent.anim_player.stop()
	_args["completed"] = false
	
func exit(parent: MC):
	.exit(parent)
	handle_anim_finished(parent)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "melee_one":
		_args["completed"] = true
