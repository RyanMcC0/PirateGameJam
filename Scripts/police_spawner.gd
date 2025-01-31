extends RigidBody2D

# Get the enemy node
var parentNode
var enemy_scene = preload("res://Scenes/enemy_police.tscn")
var explosionEffect=preload("res://Scenes/explosionParticles.tscn")
var tint_frames = 50
var current_tint_frame = 0
var is_tinted = false
var tinterShader = preload("res://Shaders/tinter.gdshader")
var shaderTint = 0.3
var shaderColor = Color.WHITE
var curr_health = 2
var fire_frames = 1000
var current_fire_frame = 0
var is_fired = false
var is_destroyed = false
var respawnTime = 1.5
var respawn_timer = 0.0
var is_respawning = false
var current_spawned = 0
var spawnTop = false

@onready var UI: Node2D = get_tree().get_root().get_node("Node2D/Player/UI/Ui")

# Seconds for spawn delay
var spawn_delay = 5.0

# Increase to check spawn delay
var spawn_check_timer = 0.0

# How far away from car the police should spawn
var spawn_offset_bottom: Vector2 = Vector2(-15,50)
var spawn_offset_top: Vector2 = Vector2(-15,-50)
var health_max = 3

@onready var root = get_tree().get_root().get_node("Node2D")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lock_rotation = true
	freeze = true
	$Car.play("idle")
	$Car.material = ShaderMaterial.new()
	$Car.material.shader = tinterShader
	$Car.material.set_shader_parameter("color", shaderColor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_destroyed:
		spawn_check_timer += delta
	else:
		spawn_check_timer = 0
	if spawn_check_timer >= spawn_delay:
		spawn_enemy()
		spawn_check_timer = 0.0
		
	if is_tinted:
		current_tint_frame += 1
		if current_tint_frame >= tint_frames:
			remove_red_tint()
	
	if is_fired:
		current_fire_frame += 1
		if current_fire_frame >= fire_frames:
			$Car.play("burned")
	
func _physics_process(delta: float) -> void:
	if is_respawning and !is_destroyed:
		respawn_timer = clamp(respawn_timer - delta, 0, respawnTime)
		update_respawn_animation()
	if respawn_timer == 0 and !is_destroyed:
		is_respawning = false
		$Car.play("idle")

func start_respawn() -> void:
	UI.increasePolice()
	is_respawning = true
	respawn_timer = respawnTime
	$Car.animation = "spawn_enemy"
	
func update_respawn_animation() -> void:
	var frame_duration = respawnTime / 5.0  # Calculate the duration of each frame
	var current_frame = int((respawnTime - respawn_timer) / frame_duration)
	$Car.frame = current_frame
	if current_frame == 5:
		$Car.play("idle")
		is_respawning = false
		respawn_timer = 0

func spawn_enemy() -> void:
	if(current_spawned < 2):
		start_respawn()
		var new_enemy = enemy_scene.instantiate()
		new_enemy.parentObj = self
		if !spawnTop:
			new_enemy.position = self.position + spawn_offset_bottom
			spawnTop = !spawnTop
		else:
			new_enemy.position = self.position + spawn_offset_top
			spawnTop = !spawnTop
		get_parent().add_child(new_enemy)
		current_spawned += 1
		root.enemyCount += 1

func reduce_spawn_count() -> void:
	current_spawned -= 1
	root.enemyCount -= 1
	UI.decreasePolice()
	if current_spawned == 0:
		root.level_clear_check()

func _on_bullet_hit() -> void:
	spawn_check_timer = 0.0
	apply_red_tint()
	health_max -= 1
	if(health_max <= 0) and !is_destroyed:
		$Car.play("fire")
		is_fired = true
		is_destroyed = true
		explode()

func explode() -> void:
	var particle = explosionEffect.instantiate()
	particle.position = global_position
	particle.rotation = global_rotation
	particle.emitting = true
	get_tree().current_scene.add_child(particle)
	parentNode.reduce_spawners()
	
func apply_red_tint() -> void:
	$Car.material.set_shader_parameter("tint_amount", shaderTint)
	is_tinted = true
	current_tint_frame = 0

func remove_red_tint() -> void:
	$Car.material.set_shader_parameter("tint_amount", 0.0)
	is_tinted = false
