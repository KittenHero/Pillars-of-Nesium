extends Node2D

const MCPS = preload("res://src/main/player/MC.tscn")
var mc

func spawn_player() -> MC:
	var scene = get_tree().current_scene
	if mc:
		scene.remove_child(mc)
	mc = MCPS.instance()
	mc.global_position = self.global_position
	mc.get_node('Hurtbox').connect('dead', self, 'spawn_player')
	mc.get_node('Hurtbox').connect('hazard', self, 'respawn_player')
	scene.add_child(mc)
	return mc

func respawn_player() -> void:
	mc.global_position = self.global_position
	mc.velocity = Vector2.ZERO

func _on_checkpoint(position: Vector2) -> void:
	self.global_position = position
