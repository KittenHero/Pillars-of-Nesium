extends Area2D
class_name PlayerHP

onready var player = get_parent()
onready var max_hp = player.max_health
onready var current_hp = player.max_health setget _set_hp
var hitboxes = []
onready var immunity_timer = player.get_node('Timers/ImmunityTimer')
onready var status_anim = player.get_node('StatusAnim')
onready var anim_player = player.get_node('AnimationPlayer')
onready var respawn_timer = player.get_node('Timers/RespawnTimer')


const hp_ui_scene = preload('res://src/UI/HP/HealthOrbsDisplay.tscn')
onready var ui_interface = get_tree().current_scene.get_node("UI/Interface")
onready var hp_ui = hp_ui_scene.instance()

signal health_updated(health)
signal dead()
signal hazard()

func _ready() -> void:
	ui_interface.add_child(hp_ui)
	hp_ui.set_max_health(max_hp)
	connect("health_updated", hp_ui, "_on_health_updated")

func _process(delta: float) -> void:
	if !immunity_timer.is_stopped() or hitboxes.size() == 0 or current_hp <= 0: return
	var max_dmg = 0
	var hazard = false
	for hitbox in hitboxes:
		hazard = hazard or hitbox.hazard
		max_dmg = max(max_dmg, hitbox.damage_value)
	immunity_timer.start()
	_set_hp(current_hp - max_dmg)
	status_anim.queue("damage")
	status_anim.queue("flash")
	if hazard and current_hp > 0 and respawn_timer.is_stopped():
		player.set_physics_process(false)
		respawn_timer.start()

func _set_hp(value):
	var prev_hp = current_hp
	current_hp = clamp(value, 0, max_hp)
	if current_hp != prev_hp:
		emit_signal("health_updated", current_hp)
	if current_hp == 0:
		kill()

func kill():
	emit_signal("dead")
	player.queue_free()
	hp_ui.queue_free()

func _on_ImmunityTimer_timeout() -> void:
	status_anim.play("RESET")

func _on_RespawnTimer_timeout() -> void:
	if current_hp > 0:
		emit_signal("hazard")
		while player.stack.size() > 0:
			player.pop_state()
		player.set_physics_process(true)

func _on_Hurtbox_area_entered(hitbox: Area2D) -> void:
	assert(hitbox is Hitbox, "Hitbox collision layer not set correctly")
	hitboxes.append(hitbox)

func _on_Hurtbox_area_exited(hitbox: Area2D) -> void:
	assert(hitbox is Hitbox, "Hitbox collision layer not set correctly")
	hitboxes.erase(hitbox)


