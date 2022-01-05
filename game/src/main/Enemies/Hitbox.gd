extends Area2D
class_name Hitbox

export var damage_value = 4

# this ensures enemies can only dmg the player and not each other
var faction_exceptions = []

func add_faction_exception(faction) -> void:
	faction_exceptions.append(faction)

func adjust_damage(damage) -> void:
	damage_value = damage



