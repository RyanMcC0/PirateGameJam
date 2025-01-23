extends EnemyBase

#Node references
var player: Node2D
var ray_caster: RayCast2D
var Bullet = preload("res://Scenes/BulletProj.tscn")

#Global variables
var shooting_distance = 400
var movement_speed = 100
var safe_distance = 100
var accel = 5
var player_location
var bullet_speed = 1500
var bullet_offset = Vector2(80,-30)
var impact_strength = 1500
var shot_timer = 0.0
var fire_rate = 1
var moving = false
var tint_frames = 30
var current_tint_frame = 0
var is_tinted = false
var tinterShader = preload("res://Shaders/tinter.gdshader")
var shaderTint = 0.3
var shaderColor = Color.RED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("Player")
	ray_caster = $RayCast2D
	ray_caster.enabled = true
	lock_rotation = true
	var sprite = $Legs
	var sprite2 = $TorsoSprite
	$Legs.material = ShaderMaterial.new()
	$Legs.material.shader = tinterShader
	$Legs.material.set_shader_parameter("color", shaderColor)
	sprite2.material = ShaderMaterial.new()
	sprite2.material.shader = tinterShader
	sprite2.material.set_shader_parameter("color", shaderColor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_location = player.position
	move(delta)
	if is_tinted:
		current_tint_frame += 1
		if current_tint_frame >= tint_frames:
			remove_red_tint()

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
		$Legs.stop
		$Legs.frame = 0
		if(shot_timer >= fire_rate):
			attack(direction)
	elif distance < distance_lower_bound:
		retreat(direction)
		if not moving:
			$Legs.play("walk")
		switch_anim(convertToCardinal(Vector2(-(self.position.x - player_location.x), self.position.y - player_location.y)))
		if(shot_timer >= fire_rate):
			attack(direction)
			
	elif distance > distance_upper_bound:
		pursue(direction)
		if not moving:
			$Legs.play("walk")
		switch_anim(convertToCardinal(Vector2(-(self.position.x - player_location.x), self.position.y - player_location.y)))
		

func attack(direction) -> void:
	var bullet_instance = Bullet.instantiate()
	bullet_instance.rotation = rotation+(PI/2)
	# Calculate the global position for the bullet using the offset
	bullet_instance.position = global_position + (transform.basis_xform(bullet_offset))
	#get_parent().add_child(bullet_instance)
	#bullet_instance.linear_velocity = bullet_speed * direction
	play_anim_shoot()
	shot_timer = 0.0

func retreat(direction) -> void:
	linear_velocity = linear_velocity.move_toward(-direction*movement_speed, accel)

func pursue(direction) -> void:
		linear_velocity = linear_velocity.move_toward(direction*movement_speed, accel)


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
func convertToCardinal(velocity: Vector2) -> int:
	if velocity == Vector2.ZERO:
		return 2
		
	if abs(velocity.x) > abs(velocity.y):
		#Horizontal movement
		if velocity.x > 0:
			return 1
		else:
			return 3
	else:
		#Vertical movement
		if velocity.y > 0:
			return 0
		else:
			return 2

func switch_anim(facing: int) -> void:
	match facing:
		0: $TorsoSprite.animation = "ShootingNorth"
		1: $TorsoSprite.animation = "ShootEast"
		2: $TorsoSprite.animation = "ShootSouth"
		3: $TorsoSprite.animation = "ShootWest"

func play_anim_shoot() -> void:
	$TorsoSprite.play()

func _on_melee_hit() -> void:
	var direction = (player_location - self.position).normalized()
	apply_central_impulse(-direction*impact_strength)
	apply_red_tint()

func apply_red_tint() -> void:
	$Legs.material.set_shader_parameter("tint_amount", shaderTint)
	$TorsoSprite.material.set_shader_parameter("tint_amount", shaderTint)
	is_tinted = true
	current_tint_frame = 0

func remove_red_tint() -> void:
	$Legs.material.set_shader_parameter("tint_amount", 0.0)
	$TorsoSprite.material.set_shader_parameter("tint_amount", 0.0)
	is_tinted = false
