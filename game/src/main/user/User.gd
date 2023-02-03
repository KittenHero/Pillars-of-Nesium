extends KinematicBody2D
class_name User

onready var controller = $Controller

func _ready():	
	controller.anim_sprite = $Sprite
	controller.anim_player = $AnimationPlayer
	controller.stand_left = $Stand1
	controller.stand_right = $Stand2
	controller.player_collision_shape = $CollisionShape2D
	controller.tile_detection_u = $TileDetection/u
	controller.tile_detection_l = $TileDetection/l
	controller.tile_detection_d = $TileDetection/d
	controller.tile_detection_r = $TileDetection/r
	controller.target = self 
	controller.setup()

func _physics_process(delta) -> void:
	pass	
