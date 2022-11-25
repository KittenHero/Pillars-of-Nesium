extends Area2D

signal savepoint(position)

func _on_Savepoint_body_entered(body):
	assert(body is MC, 'Collision Layers not set correctly')
	emit_signal('savepoint', self.global_position)
