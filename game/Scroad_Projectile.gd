extends KinematicBody2D

const THROW_VELOCITY = Vector2(800, -400)

var velocity = Vector2.ZERO

func _ready():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	velocity.y = Globals.gravity * delta
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		# Handle Collision
		queue_free()

func _launch(direction):
	var temp = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	velocity = THROW_VELOCITY * Vector2(direction, 1)
	set_physics_process(true)
