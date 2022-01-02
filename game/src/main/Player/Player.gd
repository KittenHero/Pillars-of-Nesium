extends KinematicBody2D
class_name Player

signal damaged(amount)
signal health_updated(health)
signal dead()

export (float) var max_health = 5
export (float) var move_speed_units = 2 setget _set_move_speed_units
export (float) var move_weight = 0.2

onready var health = max_health setget _set_health

const UP = Vector2(0, -1)
const SLOPE_STOP = 64

onready var state_machine = $PlayerFSM
onready var body = $Body
onready var raycasts = $Raycasts
onready var anim_player = $BasicAnimations
onready var effects_animation = $EffectsAnimation
onready var immunity_timer = $Timers/InvulnerabilityTimer

var velocity = Vector2.ZERO
onready var move_speed = move_speed_units * 96 setget _set_move_speed
var gravity = Globals.gravity
var jump_velocity = -200
var is_grounded
var is_jumping = false

func _ready():
	Globals.player = self
	var health_bar = get_tree().current_scene.player_health_bar
	health_bar.set_max_health(max_health)
	connect("health_updated", health_bar, "_on_health_updated")
	connect("health_updated", self, "_on_health_updated")

func _apply_gravity(delta):
	velocity.y += gravity * delta
	
func _apply_movement():
	# Identify jumping/falling
	if is_jumping && velocity.y >= 0:
		is_jumping = false
		
	var snap = Vector2.DOWN * 32 if !is_jumping else Vector2.ZERO
	
	velocity = move_and_slide_with_snap(velocity, snap, UP)
	
#	var was_grounded = is_grounded
#	is_grounded = !is_jumping && _check_is_grounded()
#
#	if was_grounded == null || is_grounded != was_grounded:
#		emit_signal("grounded_up", is_grounded)

func _handle_move_input():
#	var move_direction = -int(Input.is_action_just_pressed("move_left")) + int(Input.is_action_just_pressed("move_right"))
	var move_direction = -int(Input.get_action_strength("move_left")) + int(Input.get_action_strength("move_right"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	if move_direction != 0:
		body.scale.x = move_direction
	else:
		if (velocity.x < 0 && velocity.x > -1) || (velocity.x > 0 && velocity.x < 1):
			velocity.x = 0

func _get_h_weight():
	return 0.2 if is_grounded else 0.1
		
func _check_is_grounded(raycasts = self.raycasts):
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
			
	# Not grounded
	return false

func damage(amount):
	if immunity_timer.is_stopped():
		immunity_timer.start()
		_set_health(health - amount)
		emit_signal("damaged", amount) # can be used in future to play some effects i.e. screen shake
		effects_animation.play("Damage")
		if health != 0:
			effects_animation.queue("Flash")
	return amount
		
func kill():
	emit_signal("dead")
	queue_free()
	
func _set_move_speed_units(value):
	move_speed = value * 96
	move_speed_units = value
	
func _set_move_speed(value):
	move_speed = value
	move_speed_units = value / 96
		
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	emit_signal("health_updated", health, health-prev_health) # send new health, damage taken
	if health != prev_health:
		if health == 0:
			kill()
			
func _on_health_updated(health, amount):
	pass
		
func _on_InvulnerabilityTimer_timeout() -> void:
	effects_animation.play("RESET")
