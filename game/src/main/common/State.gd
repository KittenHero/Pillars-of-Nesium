extends Node
class_name State
	
var _args = {}

func physics_process(_delta: float):
	pass

func anim_process(_delta: float):
	pass

func handle_anim_finished():
	pass

func enter():
	pass
	
func exit():
	_args = {}

func set_args(args = {}):
	_args = args

