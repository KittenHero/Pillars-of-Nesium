extends KinematicBody2D
onready var playerdect = $Playerdetection
onready var sprite = $AnimatedSprite
const Floor = Vector2(0,1)
var speed = 30
var direction = 1
var velocity = Vector2()
var state = IDLE
var tpath = 0
export var max_health = 25

var attack_range = 50
var charge_timer = 2.0
var attack_swoop_speed = 500
var attack_arc_height = 100
var attack_arc_duration = 1.0
var attack_charge_time = 0.0
var attack_position = Vector2()
var attack_arc_start_position = Vector2()
var attack_arc_end_position = Vector2()
var attack_arc_timer = 0.0

func _ready():
	pass # Replace with function body.

enum{
	IDLE,
	WANDER,
	CHASE,
	KILL
}

signal touching_player()

func _on_Hitbox_area_entered(area):
	if area != $Hurtbox:
		emit_signal("touching_player")

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
		
	match state:
		IDLE:
			sprite.play("flap")
			velocity.x = -speed * direction
			seek_player()
		WANDER:
			sprite.play("charge") # make of progressivly slower flapping
			state = IDLE
		CHASE:
			var player = playerdect.player
			speed = 60
			if player != null:
				var direction:Vector2 = (player.global_position + Vector2(80,-100) - global_position)
				velocity = velocity.move_toward(direction.normalized() * speed, delta)
				if global_position == player.global_position + Vector2(0,-100):
					state = KILL
		KILL: # Move in arc towards player
			if charge_timer < attack_charge_time:
				charge_timer += delta
				sprite.play("charge")
			else:
				charge_timer = 0.0
				sprite.play("swoop")
				if attack_arc_timer > 0:
					var t = 1.0 - (attack_arc_timer / attack_arc_duration)
					var x = lerp(attack_arc_start_position.x,attack_arc_end_position.x,t)
					var y = attack_arc_start_position.y + attack_arc_height * sin(t*PI)
					velocity = Vector2(x, y) - position
					velocity = velocity.normalized() * attack_swoop_speed
					attack_arc_timer -= delta	# Decrease arc timer
				else:
					var direction = (attack_position - position).normalized()
					velocity = direction * attack_swoop_speed
			state = WANDER
			
func seek_player():
	if playerdect.can_see_player():
		state = CHASE


				#	else:
				#state = IDLE
				#velocity.y = 0
			#sprite.flip_h = velocity.x >0		
