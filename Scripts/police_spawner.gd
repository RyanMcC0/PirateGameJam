extends RigidBody2D

# Get the enemy node
var enemy_scene = preload("res://Scenes/enemy_police.tscn")

# Seconds for spawn delay
var spawn_delay = 5.0

# Increase to check spawn delay
var spawn_check_timer = 0.0

# How far away from car the police should spawn
var spawn_offset: float = 150.0

var health_max = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lock_rotation = true
	freeze = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_check_timer += delta
	if spawn_check_timer >= spawn_delay:
		spawn_enemy()
		spawn_check_timer = 0.0

func spawn_enemy() -> void:
	var body_position = self.position
	var body_rotation = self.rotation
	var body_size = self.get_node("CollisionShape2D").shape.get_rect().size
	var long_side_direction = Vector2(cos(body_rotation), sin(body_rotation)).normalized()
	var spawn_position = body_position + long_side_direction * (body_size.length() / 2 + spawn_offset)
	
	var new_enemy = enemy_scene.instantiate()
	new_enemy.position = spawn_position
	get_parent().add_child(new_enemy)

func _on_bullet_hit() -> void:
	health_max -= 1
	if(health_max <= 0):
		queue_free()
