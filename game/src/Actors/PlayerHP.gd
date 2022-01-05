extends Area2D
class_name PlayerHP

onready var max_hp = get_parent().max_health
onready var current_hp = get_parent().max_health setget _set_hp
var hitboxes = []
onready var immunity_timer = get_parent().get_node('Timers/ImmunityTimer')
onready var status_anim = get_parent().get_node('StatusAnim')
onready var death_timer = get_parent().get_node('Timers/DeathTimer')


const hp_ui_scene = preload('res://src/UI/HP/HealthOrbsDisplay.tscn')
onready var ui_interface = get_tree().current_scene.get_node("UI/Interface")
onready var hp_ui = hp_ui_scene.instance()

signal health_updated(health)
signal dead()

func _ready() -> void:
	ui_interface.add_child(hp_ui)
	hp_ui.set_max_health(max_hp)
	connect("health_updated", hp_ui, "_on_health_updated")

func _process(delta: float) -> void:
	if !immunity_timer.is_stopped() or hitboxes.size() == 0 or current_hp <= 0: return
	var max_dmg = 0
	for hitbox in hitboxes:
		max_dmg = max(max_dmg, hitbox.damage_value)
	immunity_timer.start()
	_set_hp(current_hp - max_dmg)
	status_anim.queue("damage")
	status_anim.queue("flash")

func _set_hp(value):
	var prev_hp = current_hp
	current_hp = clamp(value, 0, max_hp)
	if current_hp != prev_hp:
		emit_signal("health_updated", current_hp)
	if current_hp == 0:
		kill()

func kill():
	death_timer.start()

func _on_ImmunityTimer_timeout() -> void:
	status_anim.play("RESET")

func _on_DeathTimer_timeout() -> void:
	emit_signal("dead")
	get_parent().queue_free()
	hp_ui.queue_free()

func _on_Hurtbox_area_entered(hitbox: Area2D) -> void:
	assert(hitbox is Hitbox, "Hitbox collision layer not set correctly")
	hitboxes.append(hitbox)

func _on_Hurtbox_area_exited(hitbox: Area2D) -> void:
	assert(hitbox is Hitbox, "Hitbox collision layer not set correctly")
	hitboxes.erase(hitbox)


