extends CharacterBody2D
class_name BaseEntity

@export var max_health : float
@export var max_speed: float
@export var current_health : float
@export var is_dead = false
@export var is_hurt = false


@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _health_component: HealthComponent = $HealthComponent

