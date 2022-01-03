extends Area2D


func _on_Checkpoint_body_entered(body):
	if body.name == "MC":
		Globals.update_spawnpoint(self.global_position)
