extends Node
class_name  HealthComponent

signal died
signal health_changed

var entity: BaseEntity

func _ready():
	entity = owner as BaseEntity

func damage(dmg: float):
	entity.current_health = entity.current_health - dmg
	health_changed.emit()
	
	if entity.current_health <= 0:
		entity.is_dead = true
		var current_animation = entity._animated_sprite.animation.split("_")
		entity._animated_sprite.play("dead_" + str(current_animation[1]))
		await entity._animated_sprite.animation_finished
		died.emit()
	else:
		entity.is_hurt = true
		var current_animation = entity._animated_sprite.animation.split("_")
		entity._animated_sprite.play("hurt_" + str(current_animation[1]))
		await entity._animated_sprite.animation_finished
		entity.is_hurt = false


func get_health_percent():
	if entity.max_health == 0:
		return 0
	return min(entity.current_health / entity.max_health, 1)
