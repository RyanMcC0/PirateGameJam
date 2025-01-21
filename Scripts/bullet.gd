extends RigidBody2D

func _ready() -> void:
	continuous_cd = RigidBody2D.CCDMode.CCD_MODE_CAST_RAY
	contact_monitor = true
	max_contacts_reported = 5 # may need to change value
	connect("body_entered", _on_body_entered)

func _physics_process(delta: float) -> void:
	pass

#method for detecting collision, inherited from RigidBody2D
func _on_body_entered(collided: Node2D) -> void:
	#uncomment for debugging bullet collision
	#print(collided)
	if collided is EnemyBase:
		collided._on_bullet_hit()
		queue_free()
	elif collided is TileMapLayer:
		queue_free()#
	elif collided.name == "player":
		if collided.has_method("take_damage"):
			collided.take_damage(1)
		queue_free()
