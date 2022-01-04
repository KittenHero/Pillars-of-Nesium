extends Area2D

signal checkpoint(position)

func _on_Checkpoint_body_entered(body):
	assert(body is MC, 'Collision Layers not set correctly')
	emit_signal('checkpoint', self.global_position)
