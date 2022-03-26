extends PathFollow2D

var speed  = 20

func _process(delta):
	set_offset(get_offset() + speed + delta)
