extends Node2D

func _ready() -> void:
	$Spawn.spawn_player()
	for checkpoint in $Checkpoints.get_children():
		checkpoint.connect('checkpoint', $Spawn, '_on_checkpoint')
