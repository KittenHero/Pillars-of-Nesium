extends KinematicBody2D

const ACCELERATION = 15
const MAX_SPEED = 200
const FRICTION = 15

var velocity = Vector2.ZERO

<<<<<<< Updated upstream
func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
=======
func _ready():
	Globals.player = self
	self.position = Globals.spawn_point
	var health_bar = get_tree().current_scene.player_health_bar
	health_bar.set_max_health(max_health)
	connect("health_updated", health_bar, "_on_health_updated")

func _apply_gravity(delta):
	velocity.y += gravity * delta
	
func _apply_movement():
	# Identify jumping/falling
	if is_jumping && velocity.y >= 0:
		is_jumping = false
		
	var snap = Vector2.DOWN * 32 if !is_jumping else Vector2.ZERO
	
	velocity = move_and_slide_with_snap(velocity, snap, UP)
>>>>>>> Stashed changes
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_collide(velocity)
