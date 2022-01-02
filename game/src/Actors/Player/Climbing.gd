extends "res://src/Actors/State.gd"

var anim_direction := Vector2.RIGHT

func physics_process(parent: KinematicBody2D, delta: float):
	if not parent.can_climb:
		parent.pop_state()
	var velocity = parent.climb(delta)
	parent.velocity = parent.move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		parent.pop_state({"jump": "true"})
	anim_process(parent, delta)

func anim_process(parent: KinematicBody2D, _delta: float):
	if parent.velocity == Vector2.ZERO:
		parent.anim_player.stop(false)
		return 
	match anim_direction:
		Vector2.RIGHT:
			parent.anim_sprite.set_flip_h(true)
			parent.anim_player.play("climbing_horizontal")
		Vector2.LEFT:
			parent.anim_sprite.set_flip_h(false)
			parent.anim_player.play("climbing_horizontal")
		Vector2.UP:
			parent.anim_player.play("climbing_vertical")
		Vector2.DOWN:
			parent.anim_player.play_backwards("climbing_vertical")
		
func handle_anim_finished(parent: KinematicBody2D):
	parent.anim_player.stop()

func enter(parent: KinematicBody2D):
	if "climb" in _args and _args["climb"]:
		parent.velocity = Vector2.ZERO
	else:
		parent.pop_state()
	
func exit(parent: KinematicBody2D):
	.exit(parent) 
	handle_anim_finished(parent)
