extends Node
class_name PlayerState
	
var _args = {}

func physics_process(_parent: MC, _delta: float):
	pass

func anim_process(_parent: MC, _delta: float):
	pass

func handle_anim_finished(_parent: MC):
	pass

func enter(_parent: MC):
	pass
	
func exit(_parent: MC):
	_args = {}

func set_args(args = {}):
	_args = args


