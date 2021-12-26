extends StateMachine

func _ready():
	add_state("idle")
	add_state("telegraph")
	add_state("attack")
	call_deferred("set_state", states.idle)
	
func _state_logic(delta):
	parent._apply_gravity(delta)
	
	if state != states.attack && parent._should_turn():
		parent._turn()
		
	if state == states.chase:
		parent._chase_player()
	else:
		parent._stop()
		
	parent._apply_velocity()
	
func _get_transition(delta):
	match state:
		states.idle:
			# if sees player ATTACK
			pass
		states.telegraph:
			# ATTACK after animation
			pass
		states.attack:
			# if attack is over IDLE
			pass
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.telegraph:
			parent.telegraph_attack()
			parent.anim_player.play("telegraph")
			# start telegraph timer
		states.attack:
			parent.attack()
			
func _exit_state(old_state, new_state):
	pass
		
