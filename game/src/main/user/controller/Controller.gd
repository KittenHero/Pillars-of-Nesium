tool

extends Node

class_name SetupUser

export var starting_stats : Resource

var anim_sprite: Sprite
var anim_player: AnimationPlayer
var stand_left: RayCast2D
var stand_right: RayCast2D
var player_collision_shape: CollisionShape2D
var tile_detection_u: RayCast2D
var tile_detection_l: RayCast2D
var tile_detection_d: RayCast2D
var tile_detection_r: RayCast2D
var target: KinematicBody2D

onready var main = $UserMain

var frame_count = 0
var stack = []
var stack_buffer: int
var current_state = null
var ready = false

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
	"idle": $States/Idle,
	"airborne": $States/Airborne,
	"running": $States/Running,
}
onready var entry_state = "idle"

func setup():
	assert(anim_sprite, "Sprite not defined")
	assert(anim_player, "AnimationPlayer not defined")
	assert(stand_left, "StandLeft not defined")
	assert(stand_right, "StandRight not defined")
	assert(player_collision_shape, "CollisionShape not defined")
	assert(tile_detection_u, "TileDetectionU not defined")
	assert(tile_detection_l, "TileDetectionL not defined")
	assert(tile_detection_d, "TileDetectionD not defined")
	assert(tile_detection_r, "TileDetectionR not defined")
	assert(target, "Target not defined")
	
	main.anim_sprite = anim_sprite
	main.anim_player = anim_player
	main.stand_left = stand_left
	main.stand_right = stand_right
	main.player_collision_shape = player_collision_shape
	main.tile_detection_u = tile_detection_u
	main.tile_detection_l = tile_detection_l
	main.tile_detection_d = tile_detection_d
	main.tile_detection_r = tile_detection_r
	main.target = target	
	main.initialize_stats(starting_stats)
	
	stack_buffer = starting_stats.stack_buffer
	
	for state in state_dict:
		state_dict[state]._user = main
		state_dict[state].connect("push_state", self, '_on_push_state')
		state_dict[state].connect("pop_state", self, '_on_pop_state')
	
	ready = true

func _ready():
	current_state = state_dict[entry_state]

	
func _physics_process(delta) -> void:
	if(ready):
		frame_count += 1
		current_state.physics_process(delta)

func _on_push_state(state, args = {}) -> void:
	assert(state in state_dict, "Cannot push unknown state: %s" % state)
	if current_state:
		current_state.exit()
		stack.push_front(current_state)
		if stack.size() > stack_buffer:
			print("Something went wrong in stack management, buffer exceeded & lost the oldest state")
			stack.pop_back()
	current_state = state_dict[state]
	current_state.set_args(args)
	current_state.enter()

func _on_pop_state(state, args={}) -> void:
	assert(stack, "Buffer empty")
	if current_state:
		current_state.exit()
	var next_state = stack.pop_front()
	if next_state:
		current_state = next_state
		current_state.set_args(args)
		current_state.enter()

func print_stack_states():
	print("Position: ", self.position)
	var names = []
	for state in stack:
		names.push_back(state)
	print("<- ", current_state, ":", current_state._args, " : ", names)

