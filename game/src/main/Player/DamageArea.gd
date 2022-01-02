extends Area2D

signal entity_damaged(entity)

export (float) var damage_amount = 5

func _on_DamageArea_area_entered(hitbox):
	if hitbox is Hitbox && is_instance_valid(hitbox.entity):
		if hitbox.entity.damage(damage_amount):
			emit_signal("entity_damaged", hitbox.entity)
			
func set_damage(value):
	damage_amount = value
