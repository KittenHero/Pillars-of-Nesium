extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Spin")
	pass # Replace with function body.

func _on_Hitbox_area_entered(area):
	if area != $Hurtbox:
		emit_signal("touching_player")
