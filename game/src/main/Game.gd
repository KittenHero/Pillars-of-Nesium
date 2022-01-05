extends Node2D

func _ready() -> void:
	$Spawn.spawn_player()
	for savepoint in $Savepoints.get_children():
		savepoint.connect('savepoint', $Spawn, '_on_savepoint')
