extends KinematicBody2D
export var max_health = 25

signal touching_player()

func _on_Hitbox_area_entered(area):
	if area != $Hurtbox:
		emit_signal("touching_player")
