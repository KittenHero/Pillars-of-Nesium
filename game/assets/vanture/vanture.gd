extends KinematicBody2D
onready var playerdect = $Playerdetection
onready var sprite = $AnimatedSprite
const Floor = Vector2(0,1)
var speed = 30
var direction = 1
var velocity = Vector2()
var state = IDLE
<<<<<<< Updated upstream
=======
var tpath = 0

>>>>>>> Stashed changes

func _ready():
	pass # Replace with function body.

enum{
	IDLE,
	WANDER,
	CHASE
}

func _physics_process(delta):
	
	#Gravity for death
	#velocity.y = Globals.gravity

	if direction == 1:
		sprite.flip_h = false
	else:
		sprite.flip_h = true		
		

	
	velocity = move_and_slide(velocity, Floor)
	
	if is_on_wall():
		direction = -direction

	#if $Position2D.is_colliding() == true:
	#	direction = -direction
	#if $Position2D2.is_colliding() == true:
	#	direction = -direction
		
	match state:
		IDLE:
			sprite.play("flap")
			velocity.x = -speed * direction
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
					#Soundeffectwarning
<<<<<<< Updated upstream
=======
					global_position == player.global_position + Vector2(0,-100)
					sprite.play("charge")
>>>>>>> Stashed changes
					sprite.play("swoop")
				
			else:
				state = IDLE
				velocity.y = 0
			sprite.flip_h = velocity.x >0

func seek_player():
	if playerdect.can_see_player():
		state = CHASE


