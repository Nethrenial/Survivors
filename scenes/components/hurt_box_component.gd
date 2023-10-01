extends Area2D
class_name HurtboxComponent

signal hit(ability: BaseAbility)

@export var health_component: HealthComponent

func _ready():
	area_entered.connect(on_area_entered)
	
	
func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	if health_component == null:
		return
	var ability = other_area.get_parent() as BaseAbility
	var dmg: float = ability.damage * ability.additional_damage_percent
	print(ability, " ", dmg)
#	if ability is WarAxeAbility:
#		print("Causing ", dmg, " with ", ability, " base dmg = ", ability.damage)
	hit.emit(ability)
	health_component.damage(dmg)
	
