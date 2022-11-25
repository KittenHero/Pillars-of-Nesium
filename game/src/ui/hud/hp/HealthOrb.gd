extends KinematicBody2D

onready var anim = $AnimationPlayer
onready var status = $StatusPlayer

func _ready():
	pass
	
func play_anim(state):
	match(state):
		"full":
			anim.play("full")
		"empty":
			anim.play("empty")
		"hp1":
			anim.play("health1")
			status.play("flash")
		"hp2":
			anim.play("health2")
			status.play("flash")
		"hp3":
			anim.play("health3")
			status.play("flash")
		"hp4":
			anim.play("health4")
			status.play("flash")
		"emptywithflash":
			anim.play("empty")
			status.play("flash")
