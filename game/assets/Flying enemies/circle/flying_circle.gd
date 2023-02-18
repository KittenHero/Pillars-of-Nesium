extends KinematicBody2D
onready var playerdect = $Playerdetection
onready var sprite = $AnimatedSprite
const Floor = Vector2(0,1)
var speed = 30
var velocity = Vector2()
var state = IDLE
var tpath = 0
var _centre
var _angle = 0
var RotateSpeed = 5
var playercentre = player.global_position + Vector2(0,-100)

func _ready():
	pass # Replace with function body.
	_centre = self.get_pos()

enum{
	IDLE,
	WANDER,
	CHASE
}

func _physics_process(delta):
		
	match state:
		IDLE:
			sprite.play("flap")
			_angle += RotateSpeed * delta
			var offset = Vector2(sin(_angle),cos(_angle))*Radius
			var pos = _centre + offset
			move(pos) 
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerdect.player
			speed = 60
			if player != null:
				var direction:Vector2 = (player.global_position + Vector2(80,-100) - global_position)
				velocity = velocity.move_toward(direction,1)
				if global_position == player.global_position + Vector2(0,-100):
					#Soundeffectwarning<<<<<<< Updated upstream
					global_position == player.global_position + Vector2(0,-100)
					sprite.play("charge") #faster flapping in place
					sprite.play("swoop") #Audio file
					var offsetattack = Vector2(sin(_angle),cos(_angle))*Radius
					var posattack = playercentre + offset
					move(posattack) 
			else:
				state = IDLE
				velocity.y = 0
			sprite.flip_h = velocity.x >0
func seek_player():
	if playerdect.can_see_player():
		state = CHASE


