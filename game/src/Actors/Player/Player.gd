extends KinematicBody2D
class_name MC

# adding in stuff for UI health bars - Kevin
signal damaged(amount)
signal health_updated(health)
signal dead()
#

export var gravity = 3000
export var max_speed = 200
export var time_to_max_speed = 20
export var jump_height = 300
export var stack_buffer = 10

# adding in stuff for UI health bars - Kevin
export (float) var max_health = 25
onready var immunity_timer = $Timers/ImmunityTimer
onready var status_anim = $StatusAnim
onready var health = max_health setget _set_health
#

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

func damage(amount):
	var amount_damaged = 0
	if immunity_timer.is_stopped():
		immunity_timer.start()
		var prev_health = health
		_set_health(health - amount)
		amount_damaged = prev_health - health
		emit_signal("damaged", amount)
		status_anim.play("damage")
		if health != 0:
			status_anim.queue("flash")
	return amount_damaged

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

func _on_InvulnerabilityTimer_timeout() -> void:
	status_anim.play("RESET")
