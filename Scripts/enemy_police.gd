extends EnemyBase

#Node references
var player: Node2D
var ray_caster: RayCast2D
var Bullet = preload("res://Scenes/BulletProj.tscn")

#Global variables
var shooting_distance = 400
var movement_speed = 100
var safe_distance = 100
var player_location
var bullet_speed = 1500
var bullet_offset = Vector2(80,-30)
var shot_timer = 0.0
var fire_rate = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("Player")
	ray_caster = $RayCast2D
	ray_caster.enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_location = player.position
	move(delta)

func _on_bullet_hit() -> void:
	queue_free()

#take player location, get to a reasonable distance
func move(delta) -> void:
	var distance = self.position.distance_to(player_location)
	var direction = (player_location - self.position).normalized()
	
	shot_timer += delta
	
	#if enemy is within safe distance and they have line of sight they should stop and shoot
	#otherwise they should move toward the player
	#if they get too close they should have a delay and then run away
	var distance_lower_bound = shooting_distance - safe_distance 
	var distance_upper_bound = shooting_distance + safe_distance
	
	#maybe if they do not have line of sight we can reposition them
	if distance >= distance_lower_bound and distance <= distance_upper_bound:
		linear_velocity = Vector2(0,0)
		if(shot_timer >= fire_rate):
			attack(direction)
	elif distance < distance_lower_bound:
		retreat(direction)
	elif distance > distance_upper_bound:
		pursue(direction)

func attack(direction) -> void:
	var bullet_instance = Bullet.instantiate()
	bullet_instance.rotation = rotation+(PI/2)
	
	# Calculate the global position for the bullet using the offset
	bullet_instance.position = global_position + (transform.basis_xform(bullet_offset))
	get_parent().add_child(bullet_instance)
	bullet_instance.linear_velocity = bullet_speed * direction
	
	shot_timer = 0.0

func retreat(direction) -> void:
	linear_velocity = -direction * movement_speed 

func pursue(direction) -> void:
	linear_velocity = direction * movement_speed


# emit ray from enemy to player along vector path
# if collision shape is found in path then no line of sight...
func is_line_of_sight() -> bool:
	ray_caster.target_position = player_location
	var collided_with = ray_caster.get_collider()
	if collided_with == player:
		print("player found")
		return true
	else:
		print("player not found")
		return false
#Returns value relating to characters facing direction # N-0 E-1 S-2 W-3 (Increases CW from north)
func get_facing() -> int:
	return 0
