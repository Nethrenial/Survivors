extends BaseEntity
class_name BaseEnemy

#@export var max_health : float
#@export var max_speed: float
#@export var current_health : float
#@export var is_dead = false
#@export var is_hurt = false
#
#
#@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var _health_component: HealthComponent = $HealthComponent
#

@onready var enemy_sfx_player = $EnemySFXPlayer as EnemySFXPlayer

func _ready():
	($HurtboxComponent as HurtboxComponent).hit.connect(on_hit)
	
	
func on_hit(ability: BaseAbility):
	if ability is SwordAbility:
		enemy_sfx_player.play("sword_hit")
	elif ability is WarAxeAbility:
		enemy_sfx_player.play("axe_hit")		
