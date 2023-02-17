extends CommonPhysics
class_name UserMain

var slide_speed_multiplier: float
var slide_gravity_multiplier: float
var slide_jump_height: int
var slide_duration: float

var max_climbing_speed: int
var max_health: int 

var anim_sprite: Sprite
var anim_player: AnimationPlayer
var stand_left: RayCast2D
var stand_right: RayCast2D
var player_collision_shape: CollisionShape2D
var tile_detection_u: RayCast2D
var tile_detection_l: RayCast2D
var tile_detection_d: RayCast2D
var tile_detection_r: RayCast2D

var anim_direction := Vector2.RIGHT

var climb_tiles = 0


var acc_per_frame
var air_acc_per_frame
var frame_count
var init_jump_velocity
var terminal_velocity
var slide_jump_velocity
var ground_offset


func initialize_stats(stats: StartingStatsMC):
	assert(anim_sprite, "Sprite not defined")
	assert(anim_player, "AnimationPlayer not defined")
	assert(stand_left, "StandLeft not defined")
	assert(stand_right, "StandRight not defined")
	assert(player_collision_shape, "CollisionShape not defined")
	assert(tile_detection_u, "TileDetectionU not defined")
	assert(tile_detection_l, "TileDetectionL not defined")
	assert(tile_detection_d, "TileDetectionD not defined")
	assert(tile_detection_r, "TileDetectionR not defined")
	
	var stats_vars = [
		"max_speed", "time_to_max_speed", "deceleration",
		"max_air_speed", "time_to_max_air_speed", "jump_height", "min_jump_height", "gravity",
		"slide_speed_multiplier", "slide_gravity_multiplier", "slide_jump_height", "slide_duration",
		"max_climbing_speed", "max_health"
	]
	
	for var_name in stats_vars:
		self[var_name] = stats[var_name]
		

	# Variable high jump physics
	self.acc_per_frame = calculate_acc_per_frame(stats.max_speed, stats.time_to_max_speed)
	self.air_acc_per_frame = calculate_acc_per_frame(stats.max_air_speed, stats.time_to_max_air_speed)
	self.init_jump_velocity = calculate_init_jump_velocity(stats.jump_height, stats.gravity)
	self.terminal_velocity = calculate_terminal_velocity(stats.jump_height, stats.min_jump_height, self.init_jump_velocity, stats.gravity)
	self.slide_jump_velocity = calculate_slide_jump_velocity(stats.slide_jump_height, stats.slide_gravity_multiplier, stats.gravity)
	self.ground_offset = calculate_ground_offset(player_collision_shape)
	self.velocity = Vector2.ZERO
	self.frame_count = 0


func _ready():
	self.frame_count = 0

func _physics_process(delta):
	self.frame_count += 1

# Rays
func can_climb() -> bool:
	return climb_tiles > 0

func can_stand() -> bool:
	return not stand_left.is_colliding() && not stand_right.is_colliding()

# Checks
func is_too_slow() -> bool:
	var is_movement_input = (Input.is_action_pressed("move_left") 
	or Input.is_action_pressed("move_right"))
	return self.velocity.length_squared() < acc_per_frame and not is_movement_input

func has_completed_slide(frame_count) -> bool:
	return self.frame_count - frame_count > self.slide_duration

# General physics
func move_horizontal(_delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		anim_direction = Vector2.LEFT
		self.velocity.x -= acc_per_frame;
	elif Input.is_action_pressed("move_right"):
		anim_direction = Vector2.RIGHT
		self.velocity.x += acc_per_frame;
	if self.velocity.x > max_speed:
		self.velocity.x = max_speed
	elif self.velocity.x < - max_speed:
		self.velocity.x = - max_speed

func move_air_horizontal(_delta: float, speed = max_air_speed):
	if Input.is_action_pressed("move_left"):
		anim_direction = Vector2.LEFT
		self.velocity.x -= air_acc_per_frame;
	elif Input.is_action_pressed("move_right"):
		anim_direction = Vector2.RIGHT
		self.velocity.x += air_acc_per_frame;
	if self.velocity.x > speed:
		self.velocity.x = speed
	elif self.velocity.x < - speed:
		self.velocity.x = - speed

func climb(_delta: float) -> void:
	if Input.is_action_pressed("move_up") and tile_detection_u.is_colliding():
		self.velocity.y = -max_climbing_speed
	elif Input.is_action_pressed("move_down") and tile_detection_d.is_colliding():
		self.velocity.y = +max_climbing_speed
	if Input.is_action_pressed("move_left") and tile_detection_l.is_colliding():
		self.velocity.x = -max_climbing_speed
	elif Input.is_action_pressed("move_right") and tile_detection_r.is_colliding():
		self.velocity.x = +max_climbing_speed


func apply_normal_jump(_delta: float):
	if Input.is_action_just_released("jump"):
		if self.velocity.y < terminal_velocity:
			self.velocity.y = terminal_velocity
	move_air_horizontal(_delta)
	apply_gravity(_delta)

func apply_slide_jump(_delta: float):
	move_air_horizontal(_delta, max_speed*slide_speed_multiplier)
	apply_gravity(_delta, slide_gravity_multiplier)

func apply_airborne(delta: float):
	move_air_horizontal(delta)
	apply_gravity(delta)
	self.velocity = self.target.move_and_slide(self.velocity, Vector2.UP)

func apply_terminal_velocity():
	self.velocity.y = terminal_velocity

func apply_jump_velocity():
	self.velocity.y = init_jump_velocity

func apply_slide_jump_velocity():
	self.velocity.y = slide_jump_velocity

func apply_slide(_delta: float) -> void:
	if anim_direction == Vector2.LEFT:
		self.velocity.x = - max_speed * slide_speed_multiplier
	elif anim_direction == Vector2.RIGHT:
		self.velocity.x = max_speed * slide_speed_multiplier

func reset_velocity() -> void:
	self.velocity = Vector2.ZERO


# Target physics 
func is_on_floor() -> bool:
	return self.target.is_on_floor()

# State physics
func apply_idle_physics(_delta: float) -> void:
	var grounded = self.target.is_on_floor()
	apply_gravity(_delta)

	self.velocity = self.target.move_and_slide(self.velocity, Vector2.UP)
	
	if grounded and self.velocity.x != 0:
		apply_stopping_friction(_delta)
		
	if self.velocity.length_squared() < self.acc_per_frame * self.acc_per_frame * 2:
		self.velocity = Vector2.ZERO

func apply_running_physics(_delta: float) -> void:
	var is_movement_input = (Input.is_action_pressed("move_left") 
	or Input.is_action_pressed("move_right"))

	move_horizontal(_delta)
	if not is_movement_input:
		apply_stopping_friction(_delta)
	self.velocity = self.target.move_and_slide_with_snap(
		self.velocity, Vector2(0, 2 * self.velocity.abs().x * _delta), Vector2.UP
	)
	
func apply_airborne_physics(_delta: float) -> void:
	self.velocity = self.target.move_and_slide(self.velocity, Vector2.UP)


func apply_sliding_physics(delta: float):
	apply_slide(delta)
	apply_gravity(delta)
	self.velocity = self.target.move_and_slide_with_snap(
		self.velocity, calculate_ground_offset(self.player_collision_shape), Vector2.UP
	)
	
func apply_climbing_physocs(delta: float):
	self.velocity = self.target.move_and_slide(self.velocity, Vector2.UP)

# Animation
func crouch_look(_delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		anim_direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		anim_direction = Vector2.RIGHT

func handle_anim_sprite():
	if anim_direction != Vector2.RIGHT:
		anim_sprite.set_flip_h(true)
	else:
		anim_sprite.set_flip_h(false)		
		
func handle_climbing_anim(delta: float):
	if (
		self.velocity == Vector2.ZERO
		and self.anim_player.assigned_animation == "climbing"
	):
		self.anim_player.stop(false)
	else:
		self.anim_player.play("climbing")

func rotate_anim_sprite():
	anim_sprite.rotation = Vector2.UP.angle_to(self.target.get_floor_normal())

func reset_anim_sprite_rotation():
	anim_sprite.rotation = 0

func play_anim_player(name):
	anim_player.play(name)

func check_anim_player(name):
	var current_anim = anim_player.assigned_animation
	if not anim_player.is_playing() or current_anim != name:
		anim_player.play(name)

func check_anim_player_fall_jump():
	if self.velocity.y >= 0:
		anim_player.play("fall")
	elif self.velocity.y <= 0:
		anim_player.play("jump")

func stop_anim_player():
	if anim_player.is_playing():
		anim_player.stop()
