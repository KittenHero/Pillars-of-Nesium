extends KinematicBody2D
class_name MC

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
export var slide_jump_height := 100
export var slide_duration := 20
export var stack_buffer := 10
export var max_climbing_speed := 150

var frame_count = 0
var velocity = Vector2.ZERO
var stack = []
var current_state = null

export var max_health = 25

enum STATES {
	FALLING,
	IDLE,
	AIRBORNE,
	MELEEONE,
	MELEETWO,
	ROLLING,
	RUNNING, 
	SLIDING,
	CLIMBING,
	CROUCHING
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
	STATES.CROUCHING: $States/Crouching
}
onready var anim_sprite = $Sprite
onready var anim_player = $AnimationPlayer
onready var entry_state = STATES.IDLE
onready var anim_direction = Vector2.RIGHT
onready var climb_tiles = 0
onready var stand_left = $stand_1
onready var stand_right = $stand_2

onready var acc_per_frame = max_speed/time_to_max_speed
onready var air_acc_per_frame = max_air_speed/time_to_max_air_speed

# Variable high jump physics
onready var init_jump_velocity = - sqrt(2*gravity*jump_height)
onready var terminal_velocity = - sqrt(
	pow(init_jump_velocity, 2) - 
	(2*gravity*(jump_height - min_jump_height))
)
onready var slide_jump_velocity = - sqrt(2*gravity*slide_gravity_multiplier*slide_jump_height)
# Variable slide jump physics
# Remove if uneeded after long jump is fine
#onready var init_slide_jump_velocity = - sqrt(2*
#	gravity*
#	slide_gravity_multiplier*
#	jump_height*
#	slide_jump_multiplier
#)
#onready var slide_terminal_velocity = - sqrt(
#	pow(init_slide_jump_velocity, 2) - 
#	(2*gravity*slide_gravity_multiplier*slide_jump_multiplier*
#	(jump_height - min_jump_height))
#)

onready var ground_offset = Vector2(
	0,
	$CollisionShape2D.position.y + $CollisionShape2D.shape.height/2
)

func _ready():
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

func move_air_horizontal(_delta: float, speed = max_air_speed) -> Vector2:
	if Input.is_action_pressed("move_left"):
		anim_direction = Vector2.LEFT
		velocity.x -= air_acc_per_frame;
	elif Input.is_action_pressed("move_right"):
		anim_direction = Vector2.RIGHT
		velocity.x += air_acc_per_frame;
	if velocity.x > speed:
		velocity.x = speed
	elif velocity.x < - speed:
		velocity.x = - speed
	return velocity

func slide(_delta: float) -> Vector2:
	if anim_direction == Vector2.LEFT:
		velocity.x = - max_speed * slide_speed_multiplier
	elif anim_direction == Vector2.RIGHT:
		velocity.x = max_speed * slide_speed_multiplier
	return velocity

func climb(_delta: float) -> Vector2:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y = -max_climbing_speed
	elif Input.is_action_pressed("move_down"):
		velocity.y = +max_climbing_speed
	if Input.is_action_pressed("move_left"):
		velocity.x = -max_climbing_speed
	elif Input.is_action_pressed("move_right"):
		velocity.x = +max_climbing_speed
	return velocity

func crouch_look(_delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		anim_direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		anim_direction = Vector2.RIGHT

func apply_stopping_friction(_delta: float) -> Vector2:
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, deceleration)
	return velocity

func apply_gravity(delta: float, gravity_scale = 1) -> Vector2:
	velocity.y += gravity * gravity_scale * delta
	return velocity

func modulate_sprite(color: Color) -> void:
	$Sprite.modulate = color

func can_climb() -> bool:
	return climb_tiles > 0

func can_stand() -> bool:
	return not stand_left.is_colliding() && not stand_right.is_colliding()

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
	print("Position: ", self.position)
	var names = []
	for state in stack:
		names.push_back(state)
	print("<- ", current_state, ":", current_state._args, " : ", names)

func _on_TileDetection_body_entered(body):
	if body == self:
		return
	if body.is_in_group('climb'):
		climb_tiles += 1

func _on_TileDetection_body_exited(body):
	if body == self:
		return 
	if body.is_in_group('climb'):
		climb_tiles -= 1

func kill() -> void:
	$Hurtbox.kill()


