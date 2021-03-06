extends "res://src/Actors/State.gd"

func physics_process(parent: MC, delta: float):
	anim_process(parent, delta)
	var velocity = parent.move_air_horizontal(delta)
	velocity = parent.apply_gravity(delta, parent.slide_gravity_multiplier)
	parent.velocity = parent.move_and_slide(velocity, Vector2.UP)
	print("Slide jumping")
	if parent.is_on_floor():
		print("popping slide jump")
		parent.pop_state()

func anim_process(parent: MC, _delta: float):
	if parent.anim_direction != Vector2.RIGHT:
		parent.anim_sprite.set_flip_h(true)
	else:
		parent.anim_sprite.set_flip_h(false)
	if parent.velocity.y >= 0:
		parent.anim_player.play("fall")
	elif parent.velocity.y <= 0:
		parent.anim_player.play("jump")

func handle_anim_finished(parent: MC):
	parent.anim_player.stop()

func enter(parent: MC):
	if "jump" in _args and _args["jump"]:
		print("In slide jump")
		parent.velocity.y = parent.init_slide_jump_velocity
	
func exit(parent: MC):
	.exit(parent) 
	handle_anim_finished(parent)
