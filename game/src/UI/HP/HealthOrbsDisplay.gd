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
	var flashed = false
	for n in range(n_orbs):
		#
		var orb = hp_orb.instance()
		orb.scale = Vector2(2,2)
		orbs.add_child(orb)
		#
		orb.global_position = Vector2(24 + (n * 48) , 24)
		if c_health >= 5:
			orb.play_anim("full")
		elif c_health == 4:
			orb.play_anim("hp4")
		elif c_health == 3:
			orb.play_anim("hp3")
		elif c_health == 2:
			orb.play_anim("hp2")
		elif c_health == 1:
			orb.play_anim("hp1")
		elif !flashed:
			orb.play_anim("emptywithflash")
		else:
			orb.play_anim("empty")
		c_health = max(0, c_health - 5)
		flashed = flashed or c_health < 0

func set_max_health(value): #intented to start
	max_health = value
	_on_health_updated(max_health, 0)
	
