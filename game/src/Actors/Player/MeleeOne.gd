extends "res://src/Actors/State.gd"

var completed

func physics_process(parent: KinematicBody2D, delta: float):
	if not "melee" in _args:
		return parent.pop_state()

	match _args["melee"]:
		"ground":
			parent.velocity = Vector2.ZERO
			print("groud melee match")
			if Input.is_action_just_pressed("melee") and parent.anim_sprite.is_playing():
				_args["next"] = parent.STATES.MELEETWO
				_args["next_args"] = {"melee": "ground"}
		"air":
			var velocity = parent.move_horizontal(delta)
			parent.apply_gravity(delta)
			parent.velocity = parent.move_and_slide(velocity, Vector2.UP)
	anim_process(parent, delta)
	if completed:
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
			parent.anim_sprite.play("melee")
		"air":
			parent.anim_sprite.play("air_melee")

func handle_anim_finished(parent: KinematicBody2D):
	parent.anim_sprite.stop()
	
func enter(parent: KinematicBody2D):
	if parent.anim_sprite.is_playing():
		parent.anim_sprite.stop()
	completed = false
	
func exit(parent: KinematicBody2D):
	.exit(parent)
	handle_anim_finished(parent)

func _on_Sprite_animation_finished():
	completed = true
