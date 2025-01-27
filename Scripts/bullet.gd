extends RigidBody2D

var speed: float = 1500.0 # bullet speed
var homing_enabled: bool = false # is homing active?
var homing_strength: float = 1.0 # strength of turning
var homing_range: float = 500.0 # max distance for homing
var target: Node = null # enemy the bullet is homing in on

func _ready() -> void:
	continuous_cd = RigidBody2D.CCDMode.CCD_MODE_CAST_RAY
	contact_monitor = true
	max_contacts_reported = 5 # may need to change value
	connect("body_entered", _on_body_entered)

func _physics_process(delta: float) -> void:
	if homing_enabled and target and is_instance_valid(target):
		adjust_direction(delta)

func adjust_direction(delta: float) -> void:
	#adjust direction towards valid target
	if target and is_instance_valid(target):
		var to_target = target.global_position - global_position # calc (slang for calculator) direction to target
		if to_target.length() > homing_range: # stop homing if out of range
			homing_range = false #Change to is in range boolean
			return
		var new_direction = linear_velocity.lerp(to_target.normalized() * speed, homing_strength * delta)
		linear_velocity = new_direction
		rotation = to_target.angle() + PI / 2

#method for detecting collision, inherited from RigidBody2D
func _on_body_entered(collided: Node2D) -> void:
	#uncomment for debugging bullet collision
	if collided is EnemyBase:
		collided._on_bullet_hit()
		queue_free()
	elif collided is TileMapLayer:
		queue_free()
	elif collided.name == "Player":
		if collided.has_method("take_damage"):
			collided.take_damage(1)
		queue_free()
	elif collided.name == "PoliceSpawner":
		if collided.has_method("_on_bullet_hit"):
			collided._on_bullet_hit()
		queue_free()
	elif collided.name == "BulletPlayer" or collided.name == "BulletEnemy":
		queue_free()
