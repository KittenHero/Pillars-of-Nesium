extends Area2D
class_name Hurtbox

onready var max_hp = get_parent().max_health
onready var current_hp = get_parent().max_health setget _set_hp
#onready var status_anim = get_parent().get_node("StatusAnim")

var hitboxes = []

signal dead()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if hitboxes.size() == 0: return
	var max_dmg = 0
	for hitbox in hitboxes:
		max_dmg = max(max_dmg, hitbox.damage_value)
	_set_hp(current_hp - max_dmg)
#	status_anim.play("damage")

func _set_hp(value: float) -> void:
	var prev_hp = current_hp
	current_hp = clamp(value, 0, max_hp)
	if current_hp == 0:
		kill()

func kill() -> void:
	emit_signal("dead")
	get_parent().queue_free()

func _on_Hurtbox_area_entered(hitbox: Area2D) -> void:
	assert(hitbox is Hitbox, "Hitbox collision layer not set correctly")
	hitboxes.append(hitbox)

func _on_Hurtbox_area_exited(hitbox: Area2D) -> void:
	assert(hitbox is Hitbox, "Hitbox collision layer not set correctly")
	hitboxes.erase(hitbox)

