extends KinematicBody2D
class_name Player

export var gravity = 3000
export var max_speed = 200
export var time_to_max_speed = 20
export var jump_height = 300
export var stack_buffer = 10

var frame_count = 0
var velocity = Vector2.ZERO
var stack = []
var current_state = null

enum STATES {
	FALLING,
	IDLE,
	AIRBORNE,
	MELEEONE,
	MELEETWO,
	ROLLING,
	RUNNING, 
}

onready var state_dict = {
	STATES.IDLE: $States/Idle,
	STATES.AIRBORNE: $States/Airborne,
	STATES.MELEEONE: $States/MeleeOne,
	STATES.MELEETWO: $States/MeleeTwo,
	STATES.ROLLING: $States/Rolling,
	STATES.RUNNING: $States/Running,
}
onready var anim_sprite = $Sprite
onready var anim_player = $AnimationPlayer
onready var acc_per_frame = max_speed/time_to_max_speed
onready var entry_state = STATES.IDLE
onready var anim_direction = Vector2.RIGHT

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

func apply_stopping_friction(_delta: float) -> Vector2:
	if is_on_floor():
		velocity.x -= velocity.sign().x * acc_per_frame
	return velocity

func apply_gravity(delta: float) -> Vector2:
	velocity.y += gravity * delta
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

func pop_state() -> void:
	assert(stack, "Buffer empty")
	if current_state:
		current_state.exit(self)
	var next_state = stack.pop_front()
	if next_state:
		current_state = next_state
		current_state.enter(self)

func print_stack_states():
	var names = []
	for state in stack:
		names.push_back(state)
	print("<- ", current_state, " : ", names)

