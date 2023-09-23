extends BaseEntity
class_name Player_1


const ACCELERATION_SMOOTHING = 25

var prev_angle: float
var num_colliding_enemies : int = 0

@onready var enemy_collision_area = $EnemyCollisionArea2D as Area2D
@onready var damage_interval_time = $DamageIntervalTimer as Timer
@onready var health_component = $HealthComponent as HealthComponent
@onready var health_bar = $HealthBar as ProgressBar

func _ready():
	max_health = 10
	max_speed = 125
	current_health = max_health
	update_heath_display()
	
	
	enemy_collision_area.body_entered.connect(on_enemy_entered)
	enemy_collision_area.body_exited.connect(on_enemy_exited)
	damage_interval_time.timeout.connect(on_damage_interval_timer_timeout)
	health_component.died.connect(on_died)
	health_component.health_changed.connect(on_health_changed)


func _process(_delta):
	if is_dead:
		return
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var angle = rad_to_deg(atan2(direction.y, direction.x)) + 90
	
	var clamped_angle = floor(angle / 45)
	if clamped_angle == -1:
		clamped_angle = 7
	
	
	if (direction.x != 0 || direction.y != 0):
		prev_angle =  clamped_angle
		_animated_sprite.play("run_" + str(clamped_angle))
		
	if(direction.x == 0 && direction.y == 0 && prev_angle != null):
		_animated_sprite.play("idle_" + str(prev_angle))
	
		
	
	var target_velocity = direction * max_speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-_delta * ACCELERATION_SMOOTHING))
	move_and_slide()
	
			
	
	
	


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func on_enemy_entered(other_body: Node2D):
	num_colliding_enemies += 1
	print("Colliding with ", num_colliding_enemies, " enemies")
	check_deal_damage()

func on_enemy_exited(other_body: Node2D):
	num_colliding_enemies -= 1
	print("Colliding with ", num_colliding_enemies, " enemies")	


func check_deal_damage():
	if num_colliding_enemies == 0 || !damage_interval_time.is_stopped():
		return
	health_component.damage(1)
	print("Current player health ", current_health)
	damage_interval_time.start()
	
func on_damage_interval_timer_timeout():
	check_deal_damage()
	
func on_health_changed():
	update_heath_display()
	
func update_heath_display():
	health_bar.value = health_component.get_health_percent()


func on_died():
	print("I'm dead suckers !!!!")
	queue_free()
