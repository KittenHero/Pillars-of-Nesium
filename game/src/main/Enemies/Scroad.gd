extends KinematicBody2D
class_name Scroad

signal damaged(amount)
signal health_updated(health)
signal killed()

export (float) var max_health = 5
export (float) var move_speed_units = 2 setget _set_move_speed_units
export (float) var move_weight = 0.1

onready var state_machine = $StateMachine
onready var body = $Body
onready var effects_animation = $StatusAnimation
onready var immunity_timer = $Timers/ImmunityTimer
onready var anim_player = $AnimationPlayer

onready var health = max_health setget _set_health

const ALERT_RANGE = 96

onready var prepare_attack_timer = $Timers/PrepareAttack
onready var attack_cooldown_timer = $Timers/AttackCooldown
onready var telegraph_timer = $Timers/TelegraphTimer
onready var health_display = $HealthDisplay

export (float) var detection_radius = 500
export (float) var chase_distance = 200
export (float) var max_attack_range = 300

export (int, -1, 1, 2) var initial_facing = 1

var velocity = Vector2.ZERO
onready var move_speed = move_speed_units * 48 setget _set_move_speed

func _ready():
	health_display.set_max_health(max_health)
	health_display.hide()

func _apply_stop_velocity():
	velocity = velocity.linear_interpolate(Vector2.ZERO, move_weight)
	
func _should_pursue_player():
	pass

func _has_target():
	pass

func _prepare_attack():
	pass

func _telegraph_attack():
	pass
	
func _update_facing():
	pass
	
func _can_alert():
	return true
	
func alert():
	pass
	
func damage(amount):
	var amount_damaged = 0
	if immunity_timer.is_stopped():
		immunity_timer.start()
		var prev_health = health
		_set_health(health - amount)
		amount_damaged = prev_health - health
		emit_signal("damaged", amount)
		effects_animation.play("Damage")
		if health != 0:
			effects_animation.queue("Flash")
	return amount_damaged

func _on_ImmunityTimer_timeout() -> void:
	effects_animation.play("RESET")

func _set_move_speed_units(value):
	move_speed = value * 48
	move_speed_units = value
	
func _set_move_speed(value):
	move_speed = value
	move_speed_units = value / 48
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	emit_signal("health_updated", health, health-prev_health)
	if health != prev_health:
		if health == 0:
			kill()
			
func _on_Enemy_health_updated(health):
	health_display.show()
			
func kill():
	emit_signal("dead")
	queue_free()
