extends Area2D

export var damage_amount = 5
var entered = []

func _on_DamageArea_area_entered(hitbox: Area2D):
	# TODO: set collision layer and mask to ensure only player hitbox
	# will be called
	if hitbox is Hitbox && is_instance_valid(hitbox.entity):
		var entity: MC = hitbox.entity
		entered.append(entity)
		entity.connect_signal("dead", self, "_on_dead")

func set_damage(value: int) -> void:
	damage_amount = value

func _process(delta: float) -> void:
	for entity in entered:
		entity.damage(damage_amount)

func _on_DamageArea_area_exited(hitbox: Area2D) -> void:
	if hitbox is Hitbox && is_instance_valid(hitbox.entity):
		var entity: MC = hitbox.entity
		entered.erase(entity)
		entity.disconnect_signal("dead", self, "_on_dead")

func _on_dead(entity: Object) -> void:
	entered.erase(entity)
