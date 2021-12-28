extends Node
class_name State
	
var _args = {}

func physics_process(_parent: KinematicBody2D, _delta: float):
	pass

func anim_process(_parent: KinematicBody2D, _delta: float):
	pass

func handle_anim_finished(_parent: KinematicBody2D):
	pass

func enter(_parent: KinematicBody2D):
	pass
	
func exit(_parent: KinematicBody2D):
	_args = {}

func set_args(args = {}):
	_args = args


