extends KinematicBody2D
class_name MC

# adding in stuff for UI health bars - Kevin
signal damaged(amount)
signal health_updated(health)
signal dead()
#

export var max_speed := 300
export var time_to_max_speed := 20
export var deceleration := 0.8
export var max_air_speed := 300
export var time_to_max_air_speed := 20
export var jump_height := 150
export var min_jump_height := 10
export var gravity := 2500
export var slide_speed_multiplier := 2
export var slide_gravity_multiplier := 0.9
export var slide_jump_multiplier := 0.9
export var slide_duration := 20
export var stack_buffer := 10
export var max_climbing_speed := 100

var frame_count = 0
var velocity = Vector2.ZERO
var stack = []
var current_state = null

# adding in stuff for UI health bars - Kevin
export (float) var max_health = 25
onready var immunity_timer = $Timers/ImmunityTimer
onready var status_anim = $StatusAnim
onready var health = max_health setget _set_health
#

enum STATES {
	FALLING,
	IDLE,
	AIRBORNE,
	MELEEONE,
	MELEETWO,
	ROLLING,
	RUNNING, 
	SLIDING,
	CLIMBING
}

onready var state_dict = {
	STATES.IDLE: $States/Idle,
	STATES.AIRBORNE: $States/Airborne,
	STATES.MELEEONE: $States/MeleeOne,
	STATES.MELEETWO: $States/MeleeTwo,
	STATES.ROLLING: $States/Rolling,
	STATES.RUNNING: $States/Running,
	STATES.SLIDING: $States/Sliding,
	STATES.CLIMBING: $States/Climbing,
}
onready var anim_sprite = $Sprite
onready var anim_player = $AnimationPlayer
onready var entry_state = STATES.IDLE
onready var anim_direction = Vector2.RIGHT
onready var can_climb = false

onready var acc_per_frame = max_speed/time_to_max_speed
onready var air_acc_per_frame = max_air_speed/time_to_max_air_speed

# Variable high jump physics
onready var init_jump_velocity = - sqrt(2*gravity*jump_height)
onready var terminal_velocity = - sqrt(
	pow(init_jump_velocity, 2) - 
	(2*gravity*(jump_height - min_jump_height))
)
# Variable slide jump physics
onready var init_slide_jump_velocity = - sqrt(2*
	gravity*
	slide_gravity_multiplier*
	jump_height*
	slide_jump_multiplier
)
onready var slide_terminal_velocity = - sqrt(
	pow(init_slide_jump_velocity, 2) - 
	(2*gravity*slide_gravity_multiplier*slide_jump_multiplier*
	(jump_height - min_jump_height))
)

func _ready():
	# adding in stuff for UI health bars - Kevin
	Globals.MC = self
	var health_bar = get_tree().current_scene.player_health_bar
	health_bar.set_max_health(max_health)
	connect("health_updated", health_bar, "_on_health_updated")
	connect("health_updated", self, "_on_health_updated")
	#
	
	# adding health orbs
	var health_orbs = get_tree().current_scene.player_health_orbs
	health_orbs.set_max_health(max_health)
	connect("health_updated", health_orbs, "_on_health_updated")
	#
	current_state = state_dict[entry_state]

func _physics_process(delta) -> void:
	frame_count += 1
	current_state.physics_process(self, delta)
	
func move_horizontal(_delta: float) -> Vector2:
	if Input.is_action_pressed("move_left"):
		anim_direction = Vector2.LEFT
		velocity.x -= acc_per_frame;
	elif Input.is_action_pressed("move_right"):
		anim_direction = Vector2.RIGHT
		velocity.x += acc_per_frame;
	if velocity.x > max_speed:
		velocity.x = max_speed
	elif velocity.x < - max_speed:
		velocity.x = - max_speed
	return velocity

func move_air_horizontal(_delta: float) -> Vector2:
	if Input.is_action_pressed("move_left"):
		anim_direction = Vector2.LEFT
		velocity.x -= air_acc_per_frame;
	elif Input.is_action_pressed("move_right"):
		anim_direction = Vector2.RIGHT
		velocity.x += air_acc_per_frame;
	if velocity.x > max_air_speed:
		velocity.x = max_air_speed
	elif velocity.x < - max_air_speed:
		velocity.x = - max_air_speed
	return velocity

func slide(_delta: float) -> Vector2:
	if anim_direction == Vector2.LEFT:
		velocity.x = - max_speed * slide_speed_multiplier
	elif anim_direction == Vector2.RIGHT:
		velocity.x = max_speed * slide_speed_multiplier
	return velocity

func climb(_delta: float) -> Vector2:
	if Input.is_action_pressed("move_up"):
		velocity.y -= max_climbing_speed
	elif Input.is_action_pressed("move_down"):
		velocity.y += max_climbing_speed
	elif Input.is_action_pressed("move_left"):
		velocity.x -= max_climbing_speed
	elif Input.is_action_pressed("move_right"):
		velocity.x += max_climbing_speed
	else:
		velocity = Vector2.ZERO
	return velocity

func apply_stopping_friction(_delta: float) -> Vector2:
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, deceleration)
	return velocity

func apply_gravity(delta: float, gravity_scale = 1) -> Vector2:
	velocity.y += gravity * gravity_scale * delta
	return velocity

func modulate_sprite(color: Color) -> void:
	$Sprite.modulate = color

func push_state(state, args = {}) -> void:
	assert(state in state_dict, "Cannot push unknown state: %s" % state)
	if current_state:
		current_state.exit(self)
		stack.push_front(current_state)
		if stack.size() > stack_buffer:
			print("Something went wrong in stack management, buffer exceeded & lost the oldest state")
			stack.pop_back()
	current_state = state_dict[state]
	current_state.set_args(args)
	current_state.enter(self)

func pop_state(args={}) -> void:
	assert(stack, "Buffer empty")
	if current_state:
		current_state.exit(self)
	var next_state = stack.pop_front()
	if next_state:
		current_state = next_state
		current_state.set_args(args)
		current_state.enter(self)

func print_stack_states():
	var names = []
	for state in stack:
		names.push_back(state)
	print("<- ", current_state, " : ", names)

func _on_ClimbDetection_body_entered(body):
	if body.is_in_group('climb'):
		can_climb = true

func _on_ClimbDetection_body_exited(body):
	if body.is_in_group('climb'):
		can_climb = false

func damage(amount):
	if immunity_timer.is_stopped():
		immunity_timer.start()
		_set_health(health - amount)
		emit_signal("damaged", amount)
		status_anim.play("damage")
		if health != 0:
			status_anim.queue("flash")
	return amount

func kill():
	emit_signal("dead")
	queue_free()
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	emit_signal("health_updated", health, health-prev_health)
	if health != prev_health:
		if health == 0:
			kill()

func _on_health_updated(health, amount):
	pass

func _on_ImmunityTimer_timeout() -> void:
	status_anim.play("RESET")

