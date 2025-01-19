extends Node2D

var ammo_count = 0
var maxAmmo
var bulletPositions = [Vector2(624,33),Vector2(626,47),Vector2(629,61),Vector2(631,75),Vector2(633,90),Vector2(636,105),Vector2(639,119),Vector2(641,139),Vector2(644,150)]
var magBulletQueue: Array[Sprite2D]
var BulletUI = preload("res://Scenes/BulletUI.tscn")
var BulletProp = preload("res://Scenes/BulletProp.tscn")

func _ready() -> void:
	$Mag.frame = ammo_count
	var player = get_parent().get_node("Player")
	maxAmmo = player.maxAmmo
	reload_inst_bullets()

func _on_rigid_body_2d_ammo_count_changed(new_ammo_count: Variant) -> void:
	ammo_count = new_ammo_count
	if ammo_count < new_ammo_count:
		reload_anim() #Calls reload animation
		reload_inst_bullets() #Reinstantiate the bullet objects in the magazine for animation
	update_mag_anim()

func update_mag_anim() -> void:
	$Mag.frame = ammo_count
	#eject_bullet()
	

func reload_anim() -> void:
	pass

func reload_inst_bullets() -> void:
	for bullet in magBulletQueue:
		bullet.queue_free()
	magBulletQueue.clear()

	for i in range(maxAmmo):
		instantiateBullet(i)

func instantiateBullet(pos: int) -> void:
	var bullet = BulletUI.instantiate()
	magBulletQueue.append(bullet)
	bullet.position = bulletPositions[maxAmmo - pos - 1]  # Adjust the position index
	add_child(bullet)  # Add the bullet to the scene

#func eject_bullet() -> void:
	#var bulletEjected = magBulletQueue.pop_back()
	#bulletEjected.queue_free()
	#BulletProp.instantiate()
