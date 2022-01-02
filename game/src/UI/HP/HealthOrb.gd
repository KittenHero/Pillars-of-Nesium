extends KinematicBody2D

onready var anim = $AnimationPlayer

func _ready():
	pass
	
func play_anim(state):
	match(state):
		"empty":
			anim.play("empty")
		"full":
			anim.play("full")
		"hp1":
			anim.play("health1")
		"hp2":
			anim.play("health2")
		"hp3":
			anim.play("health3")
		"hp4":
			anim.play("health4")
		
