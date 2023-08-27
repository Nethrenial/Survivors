extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

func _ready():
	area_entered.connect(on_area_entered)
	
	
func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	if health_component == null:
		return
	var dmg: float = (other_area.get_parent() as BaseAbility).damage
	health_component.damage(dmg)
