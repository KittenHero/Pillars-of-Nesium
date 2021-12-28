extends "res://src/Actors/State.gd"

func physics_process(parent: KinematicBody2D, delta: float):
	if not "melee" in _args:
		return parent.pop_state()
	anim_process(parent, delta)
	if "completed" in _args and _args["completed"]:
		if "next" in _args and "next_args":
			parent.push_state(_args.get("next"), _args.get("next_args"))
		else:
			parent.pop_state()
	
func anim_process(parent: KinematicBody2D, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	match _args["melee"]:
		"ground":
			parent.anim_player.play("melee_two")
		"air":
			parent.anim_player.play("air_melee")

func handle_anim_finished(parent: KinematicBody2D):
	parent.anim_player.stop()
	
func enter(parent: KinematicBody2D):
	if parent.anim_player.is_playing():
		parent.anim_player.stop()
	_args["completed"] = false
	
func exit(parent: KinematicBody2D):
	.exit(parent)
	handle_anim_finished(parent)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "melee_two":
		_args["completed"] = true
