extends Node
class_name  HealthComponent

signal died

var enemy: BaseEnemy

func _ready():
	enemy = owner as BaseEnemy

func damage(dmg: float):
	enemy.current_health = enemy.current_health - dmg
	
	if enemy.current_health <= 0:
		enemy.is_dead = true
		enemy._animated_sprite.play("dead")
		await enemy._animated_sprite.animation_finished
		died.emit()
	else:
		enemy.is_hurt = true
		enemy._animated_sprite.play("hurt")
		await enemy._animated_sprite.animation_finished
		enemy.is_hurt = false
