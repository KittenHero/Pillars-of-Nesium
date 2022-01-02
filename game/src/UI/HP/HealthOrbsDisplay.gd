extends Control

const hp_orb = preload("res://src/UI/HP/HealthOrb.tscn")

onready var orbs = $Entities/Orbs

var max_health

func _ready():
	pass

func _on_health_updated(health, amount): #will re-draw the health orbs
	for n in orbs.get_children():
		n.queue_free()
	
	# Note
	# No exact reason to use n_orbs
	# Introduce new mechanic when gaining health over max_health?
	var n_orbs = max_health / 5 
	var c_health = health
	var is_flashed = false
	for n in range(n_orbs):
		#
		var orb = hp_orb.instance()
		orbs.add_child(orb)
		#
		orb.global_position = Vector2(16 + (n * 24) , 48)
		if c_health >= 5:
			c_health-=5
			orb.play_anim("full")
		elif c_health == 4:
			c_health-=4
			orb.play_anim("hp4")
			is_flashed = true
		elif c_health == 3:
			c_health-=3
			orb.play_anim("hp3")
			is_flashed = true
		elif c_health == 2:
			c_health-=2
			orb.play_anim("hp2")
			is_flashed = true
		elif c_health == 1:
			c_health-=1
			orb.play_anim("hp1")
			is_flashed = true
		elif !is_flashed:
			orb.play_anim("emptywithflash")
			is_flashed = true
		else:
			orb.play_anim("empty")
			

func set_max_health(value): #intented to start
	max_health = value
	_on_health_updated(max_health, 0)
	
