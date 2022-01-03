extends Node2D
class_name Obstacle

onready var body = $Body
var damage_area

func _ready():
	damage_area = $Body/DamageArea
	damage_area.set_damage(2)

