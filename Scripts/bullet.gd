extends RigidBody2D
var time_in_seconds = 1
var friction = 0.90

func _physics_process(delta: float) -> void:
	linear_velocity = linear_velocity * pow(friction, delta)
	if linear_velocity.length() < 50:
		
		await get_tree().create_timer(time_in_seconds).timeout
		queue_free()
