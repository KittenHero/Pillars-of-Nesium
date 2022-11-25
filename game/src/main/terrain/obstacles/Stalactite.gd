extends KinematicBody2D
class_name Stalactite

export var gravity := 2500

onready var anim_player = $AnimationPlayer
onready var anim_body = $Body

var velocity = Vector2.ZERO
var active

func _ready() -> void:
	active = false
	anim_player.play("idle")

func _physics_process(delta) -> void:
	if active == false: return
	apply_gravity(delta)
	anime_process(delta)
	velocity = move_and_slide_with_snap(
		velocity, Vector2(0, 2 * velocity.abs().x * delta), Vector2.UP
	)
#	is_valid()
	struck()

func apply_gravity(delta: float) -> Vector2:
	velocity.y += gravity * delta
	return velocity

func anime_process(delta: float) -> void:
	anim_player.queue("fire")

func _on_trap_triggered() -> void:
	active = true

func is_valid() -> void:
	print(velocity)
	if velocity == Vector2.ZERO:
		anim_player.play("die")

func struck() -> void:
	if velocity == Vector2.ZERO:
		$Hitbox/CollisionShape2D.disabled = true

func _on_AnimationPlayer_animation_finished(anim_name):
	print(anim_name)
	if anim_name == "die":
		queue_free()

