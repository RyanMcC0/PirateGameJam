extends RigidBody2D

const friction = 0.15
var recoil_force_trans = 600
var recoil_force_rot = -5000
var rotation_speed = 15000
var target
var can_follow_cursor = true
var follow_delay = 0.3  # Adjust the delay as needed
var follow_delay_timer = 0.0


func _physics_process(delta: float) -> void:
	if follow_delay_timer > 0:
		follow_delay_timer = clamp(follow_delay_timer - delta, 0, follow_delay)
		if follow_delay_timer == 0:
			can_follow_cursor = true

	if can_follow_cursor:
		var mouse_position = get_global_mouse_position()
		target = mouse_position - global_position
		follow_cursor(delta)

	apply_friction(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			add_force()

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
	if abs(rotation - target_angle) < 0.1:
		rotation = target_angle
		angular_velocity = Vector2(0,0)
