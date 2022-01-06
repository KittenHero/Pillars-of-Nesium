tool
extends KinematicBody2D

# Waypoints node must be above because needs to load before this
onready var waypoints: = get_node(waypoints_path)

export var waypoints_path: = NodePath()
export var editor_process: = true setget set_editor_process
export var speed: = 400.0
export var vanish_at_end: = false
export var vanish_on_contact: = false

var target_position: = Vector2()
var detected: = false

func _ready() -> void:
	if not waypoints:
		set_physics_process(false)
		return 
	position = waypoints.get_start_position()
	target_position = waypoints.get_next_point_position()

func _process(delta: float) -> void:
	update()

func _physics_process(delta: float) -> void:
	if not waypoints:
		set_physics_process(false)
		return 
	var direction = (target_position - position).normalized()
	var motion = direction*speed*delta
	var distance_to_target = position.distance_to(target_position)
	if motion.length() >= distance_to_target:
		position = target_position
		target_position = waypoints.get_next_point_position()
		set_physics_process(false)
		if target_position == waypoints.get_start_position() && vanish_at_end && $RespawnTimer.is_stopped():
			_vanish()
			_reset_position()
			$RespawnTimer.start()
		else:
			$PauseTimer.start()
	else:
		position += motion

	
func _draw() -> void:
	var draw_shape = $CollisionShape2D
	var extents = draw_shape.shape.extents * 2.0
	var rect = Rect2(draw_shape.position - extents / 2.0, extents)
	var color = '000' if detected else 'fff'
	if not $RespawnTimer.is_stopped():
		color = 'ef0'
	draw_rect(rect, Color(color))

func _cleanup():
	$PauseTimer.stop()
	$RespawnTimer.stop()
	$WobbleTimer.stop()

func _vanish():
	$CollisionShape2D.set_disabled(true)
	$MCDetection.set_monitoring(false)

func _reset_position():
	detected = false
	waypoints.reset()
	position = waypoints.get_start_position()
	target_position = waypoints.get_next_point_position()

func _reset_shapes():
	$CollisionShape2D.set_disabled(false)
	$MCDetection.set_monitoring(true)

func set_editor_process(value: bool) -> void:
	editor_process = value
	
	if not Engine.editor_hint:
		return
		
	set_physics_process(value)
	_cleanup()

func _on_PauseTimer_timeout():
	set_physics_process(true)

func _on_RespawnTimer_timeout():
	_reset_shapes()
	set_physics_process(true)

func _on_WobbleTimer_timeout():
	# Already starting to respawn or has respawned
	detected = false
	if not $RespawnTimer.is_stopped():
		return
	set_physics_process(false)
	_vanish()
	_reset_position()
	$RespawnTimer.start()


func _on_MCDetection_body_entered(body):
	if body is MC and vanish_on_contact:
		# Replace with animation start
		$WobbleTimer.start()
		detected = true
