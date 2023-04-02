extends Particles2D

func _ready():
	#Blood effect for pit
	$Gorepit.emission_shape = Particles2D.EMISSION_SHAPE_RECTANGLE
	$Gorepit.emission_box = Vector2(16, 16)
	$Gorepit.gravity = Vector2(0, -50)
	$Gorepit.lifetime = -1
