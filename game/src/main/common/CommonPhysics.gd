extends Node

class_name CommonPhysics

var target: KinematicBody2D 

# Ground
var time_to_max_speed: int
var max_speed: int
var deceleration: float
var velocity: Vector2

# Airborne
var max_air_speed: float 
var time_to_max_air_speed: float
var jump_height: int
var min_jump_height: int
var gravity: float


func calculate_acc_per_frame(max_speed, time_to_max_speed):
	return max_speed / time_to_max_speed

func calculate_init_jump_velocity(jump_height, gravity):
	return - sqrt(2 * gravity * jump_height)

func calculate_terminal_velocity(jump_height, min_jump_height, init_jump_velocity, gravity):
	return - sqrt(
		pow(init_jump_velocity, 2) - 
		(2 * gravity * (jump_height - min_jump_height))
	)

func calculate_slide_jump_velocity(slide_jump_height, slide_gravity_multiplier, gravity):
	return - sqrt(2*gravity*slide_gravity_multiplier*slide_jump_height)

func calculate_ground_offset(collision_shape: CollisionShape2D):
	return Vector2(
	0,
	collision_shape.position.y + collision_shape.shape.height/2
)


func apply_stopping_friction(_delta: float) -> void:
	if target.is_on_floor():
		self.velocity.x = lerp(self.velocity.x, 0, deceleration)

func apply_gravity(delta: float, gravity_scale = 1) -> void:
	self.velocity.y += gravity * gravity_scale * delta
