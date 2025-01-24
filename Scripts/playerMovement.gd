extends RigidBody2D

const friction = 0.05
var recoil_force_trans = 1000
var recoil_force_rot = -3000
var rotation_speed = 25000
var target
var impact_strength = 350
var can_follow_cursor = true
var follow_delay = 0.3  # Adjust the delay as needed
var follow_delay_timer = 0.0
var bullet_speed = 1500
var bullet_offset = Vector2(88, -25)
var maxAmmo = 4
var ammoCount = maxAmmo
var reloadTime = 1.75
var is_reloading = false
var reload_timer = 0.0
var max_health = 3 #max health of the player
var current_health = 3 #current health of the player
var kills_since_last_heal = 0 # tracks number of kills
var kills_for_heal = 3 # number of kills required for heal
var homing_enabled: bool = false
var homing_strength: float = 1.0 # strength of turning
var homing_range: float = 500.0 # max distance for homing

signal health_changed(new_health)
signal ammo_count_changed(new_ammo_count)
signal melee_attack()

@onready var upgrade_screen = get_tree().get_root().get_node("Node2D/UpgradeScreen")
@onready var health_label = get_tree().get_root().get_node("Node2D/Ui/HealthUI/HBoxContainer/Label")

# Load the bullet scene
var Bullet = preload("res://Scenes/BulletProj.tscn")

func _ready() -> void:
	# Play the idle animation
	$AnimatedSprite2D.play("Idle")
	emit_signal("ammo_count_changed", ammoCount)
	current_health = max_health
	connect("health_changed", Callable(self, "_on_health_changed"))


func _on_health_changed(new_health: int) -> void:
	if health_label:
		health_label.text = "x" + str(new_health)
	else:
		print("Health Label is null!")

func _physics_process(delta: float) -> void:
	if follow_delay_timer > 0:
		follow_delay_timer = clamp(follow_delay_timer - delta, 0, follow_delay)
		if follow_delay_timer == 0:
			can_follow_cursor = true
			$AnimatedSprite2D.play("Idle")

	if is_reloading:
		reload_timer = clamp(reload_timer - delta, 0, reloadTime)
		if reload_timer == 0:
			is_reloading = false
			ammoCount = maxAmmo
			emit_signal("ammo_count_changed", ammoCount)
			$AnimatedSprite2D.play("Idle")

	if can_follow_cursor:
		var mouse_position = get_global_mouse_position()
		target = mouse_position - global_position
		follow_cursor(delta)

	apply_friction(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and ammoCount > 0 and not is_reloading:
			shoot_bullet()
			add_force()
	#handle damage action (press P key)
	if Input.is_action_just_pressed("damage"):
		take_damage(1)
	#handle heal action (press H key)
	if Input.is_action_just_pressed("heal"):
		heal(1)
	if Input.is_action_just_pressed("show_upgrade"):
		upgrade_screen.show_upgrade_screen(self)


func shoot_bullet() -> void:
	if ammoCount > 0:
		var bullet_instance = Bullet.instantiate()
		bullet_instance.rotation = rotation + (PI / 2)
		var bullet_direction = transform.x.normalized()
		# Calculate the global position for the bullet using the offset
		var bullet_global_position = global_position + (transform.basis_xform(bullet_offset))
		bullet_instance.position = bullet_global_position
		#check if homing is enabled and assign a target if true
		if homing_enabled:
			bullet_instance.homing_enabled = true
			bullet_instance.target = get_nearest_enemy() # get the nearest enemy to the bullet	
		get_parent().add_child(bullet_instance)
		bullet_instance.linear_velocity = bullet_speed * bullet_direction
		$AnimatedSprite2D.play("Shooting")
		ammoCount -= 1
		emit_signal("ammo_count_changed", ammoCount) #For UI
		if ammoCount == 0:
			start_reload()

func start_reload() -> void:
	is_reloading = true
	reload_timer = reloadTime
	#$AnimatedSprite2D.play("Reloading")

func add_force() -> void:
	var direction = -transform.x.normalized()  # Get the direction opposite to where the node is facing
	var force = direction * recoil_force_trans  # Adjust the force magnitude as needed
	apply_impulse(force)
	apply_torque_impulse(recoil_force_rot)
	can_follow_cursor = false
	follow_delay_timer = follow_delay

func apply_friction(delta: float) -> void:
	if linear_velocity.length() < 30:
		linear_velocity = Vector2(0,0)
	else:
		linear_velocity = linear_velocity * pow(friction, delta)

func follow_cursor(delta: float) -> void:
	var target_angle = target.angle()
	var angle_difference = wrapf(target_angle - rotation, -PI, PI)
	var angular_velocity = angle_difference * rotation_speed
	angular_velocity = clamp(angular_velocity, -rotation_speed, rotation_speed)
	apply_torque_impulse(angular_velocity * delta)
	if abs(rotation - target_angle) < 0.15:
		rotation = target_angle
		angular_velocity = Vector2(0,0)


func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health < 0:
		current_health = 0 # Prevent health going below zero
	emit_signal("health_changed", current_health) #emit new health value
	if current_health == 0:
		die() #death function

func heal(amount: int) -> void:
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	emit_signal("health_changed", current_health) #emit new health value

func die() -> void:
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn") #change scene to death scene upon player death


func _on_body_entered(collided: Node2D) -> void:
	if collided is EnemyBase:
		if collided.has_method("_on_melee_hit"):
			collided._on_melee_hit()
		var coliDirection = (collided.position - self.position).normalized()
		linear_velocity = -coliDirection * impact_strength
		emit_signal("melee_attack")

func get_nearest_enemy() -> Node:
	var nearest_enemy = null
	var shortest_distance = INF
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if is_instance_valid(enemy):
			var distance = global_position.distance_to(enemy.global_position)
			if distance < shortest_distance:
				shortest_distance = distance
				nearest_enemy = enemy
	return nearest_enemy
		
