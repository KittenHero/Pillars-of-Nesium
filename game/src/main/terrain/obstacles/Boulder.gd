extends KinematicBody2D
class_name Boulder

export var max_speed := 600
export var time_to_max_speed := 5
export var gravity := 2500
# LEFT RIGHT
export(float, -1, 1) var direction := -1
export var anim_direction = Vector2.LEFT

onready var anim_player = $AnimationPlayer
onready var anim_body = $Body
onready var raycasts = $Raycasts

onready var acc_per_frame = max_speed/time_to_max_speed

var velocity = Vector2.ZERO
var active

func _ready():
	active = false
	anim_player.play("idle")

func _physics_process(delta) -> void:
	if active == false: return
	apply_movement(delta)
	apply_gravity(delta)
	anime_process(delta)
	check_colliding()
	velocity = move_and_slide_with_snap(
		velocity, Vector2(0, 2 * velocity.abs().x * delta), Vector2.UP
	)
	
func apply_movement(delta: float) -> Vector2:
	if direction == -1:
		anim_direction = Vector2.LEFT
		velocity.x -= acc_per_frame;
	elif direction == 1:
		anim_direction = Vector2.RIGHT
		velocity.x += acc_per_frame;
	if velocity.x > max_speed:
		velocity.x = max_speed
	elif velocity.x < - max_speed:
		velocity.x = - max_speed
	return velocity

func apply_gravity(delta: float) -> Vector2:
	velocity.y += gravity * delta
	return velocity

func anime_process(delta: float) -> void:
	anim_body.get_node("Sprite").flip_h = true if sign(velocity.x) > 0 else false
	anim_player.play("rolling left")
	
func check_colliding() -> void:
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			queue_free()

func _on_trap_triggered() -> void:
	active = true
