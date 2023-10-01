extends BaseEntity
class_name Player_1


const ACCELERATION_SMOOTHING = 25

var prev_angle: float
var num_colliding_enemies : int = 0

var calculated_max_speed : float = 0

@onready var enemy_collision_area = $EnemyCollisionArea2D as Area2D
@onready var damage_interval_time = $DamageIntervalTimer as Timer
@onready var health_component = $HealthComponent as HealthComponent
@onready var health_bar = $HealthBar as ProgressBar
@onready var abilities = $Abilities

var base_max_health = 50
var base_max_speed = 200

func _ready():
	max_health = base_max_health + (MetaProgressionManager.get_current_upgrade_count("increase_health") * 0.1 *base_max_health)
	print("Player Max health is ", max_health)
	max_speed = base_max_speed + (MetaProgressionManager.get_current_upgrade_count("increase_movement_speed") * 0.1 * base_max_speed)
	print("Player Speed is ", max_speed)	
	calculated_max_speed = max_speed
	current_health = max_health
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)
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
	
		
	
	var target_velocity = direction * calculated_max_speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-_delta * ACCELERATION_SMOOTHING))
	move_and_slide()
	
			
	
	
	


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func on_enemy_entered(other_body: Node2D):
	num_colliding_enemies += 1
#	print("Colliding with ", num_colliding_enemies, " enemies")
	check_deal_damage()

func on_enemy_exited(other_body: Node2D):
	num_colliding_enemies -= 1
#	print("Colliding with ", num_colliding_enemies, " enemies")	


func check_deal_damage():
	if num_colliding_enemies == 0 || !damage_interval_time.is_stopped():
		return
	health_component.damage(1)
#	print("Current player health ", current_health)
	damage_interval_time.start()
	
func on_damage_interval_timer_timeout():
	check_deal_damage()
	
func on_health_changed():
	update_heath_display()
	
func update_heath_display():
	health_bar.value = health_component.get_health_percent()


func on_died():
#	print("I'm dead suckers !!!!")
	queue_free()


func on_ability_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary):
	if upgrade is AbilityActivate:
		abilities.add_child((upgrade as AbilityActivate).ability_controller_scene.instantiate())	
	elif upgrade is PlayerUpgrade:
		if upgrade.id.begins_with("player_move_speed"):
			var percent_increase = 0.0
			if "player_move_speed_common" in current_upgrades and "quantity" in current_upgrades["player_move_speed_common"]:
				percent_increase += current_upgrades["player_move_speed_common"]["quantity"] * 0.1

			if "player_move_speed_rare" in current_upgrades:
				percent_increase += current_upgrades["player_move_speed_rare"]["quantity"] * 0.2

			if "player_move_speed_epic" in current_upgrades:
				percent_increase += current_upgrades["player_move_speed_epic"]["quantity"] * 0.3
				
			calculated_max_speed = max_speed * (1 + percent_increase)
			
