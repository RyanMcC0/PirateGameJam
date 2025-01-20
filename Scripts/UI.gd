extends Node2D

var ammo_count = 0
var maxAmmo
var bulletPositions = [Vector2(624,33),Vector2(626,47),Vector2(629,61),Vector2(631,74),Vector2(633,90),Vector2(636,105),Vector2(639,119),Vector2(641,135),Vector2(644,150)]
var ejectPosition = Vector2(619,13)
var magBulletQueue: Array
var ejectBulletQueue: Array
var BulletUI = preload("res://Scenes/BulletUI.tscn")
var BulletProp = preload("res://Scenes/BulletProp.tscn")

func _ready() -> void:
	$Mag.frame = ammo_count
	var player = get_parent().get_node("Player")
	maxAmmo = player.maxAmmo
	ammo_count = maxAmmo
	reload_inst_bullets()

func _on_rigid_body_2d_ammo_count_changed(new_ammo_count: Variant) -> void:
	if maxAmmo != null:
		if ammo_count < new_ammo_count:
			reload_anim() #Calls reload animation
			reload_inst_bullets() #Reinstantiate the bullet objects in the magazine for animation
		else:
			eject_bullet()
		ammo_count = new_ammo_count
		update_mag_anim()

func update_mag_anim() -> void:
	$Mag.frame = ammo_count

func reload_anim() -> void:
	pass

func reload_inst_bullets() -> void:
	for bullet in magBulletQueue:
		if bullet != null:
			bullet.queue_free()
	magBulletQueue.clear()
	for bullet in ejectBulletQueue:
		if bullet != null:
			bullet.queue_free()
	magBulletQueue.clear()

	for i in range(maxAmmo):
		instantiateBullet(i)

func instantiateBullet(pos: int) -> void:
	var bullet = BulletUI.instantiate()
	magBulletQueue.append(bullet)
	bullet.position = bulletPositions[maxAmmo - pos - 1]  # Adjust the position index
	add_child(bullet)  # Add the bullet to the scene

func eject_bullet() -> void:
	if magBulletQueue.size() > 0:
		var bulletEjected = magBulletQueue.pop_front()
		var bulletPropInstance: RigidBody2D = BulletProp.instantiate()
		ejectBulletQueue.append(bulletPropInstance)
		bulletPropInstance.position = ejectPosition
		bulletPropInstance.apply_central_impulse()
		add_child(bulletPropInstance)
		bulletEjected.queue_free()

  		 # Apply random central and rotational impulses
		var randomImpulse = randomEject()
		print(randomImpulse)
		bulletPropInstance.apply_central_impulse(Vector2(randomImpulse.x, randomImpulse.y))
		bulletPropInstance.apply_torque(randomImpulse.z)

func randomEject() -> Vector3:
	return Vector3(randi_range(-100, 20), randi_range(-150, 0), randi_range(10000,50000 ))
	
