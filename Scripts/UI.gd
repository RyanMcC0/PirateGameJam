extends Node2D

var ammo_count = 0
var maxAmmo
var bulletPositions: Array
var bulletOffsets = [Vector2(0,0), Vector2(4,14), Vector2(7,28), Vector2(10,42), Vector2(12,56), Vector2(13,70), Vector2(15,84), Vector2(17,98), Vector2(19,113)]
var ejectPosition = Vector2(-10,-80)
var magOff = Vector2(13,65)
var magBulletQueue: Array
var ejectBulletQueue: Array
var BulletUI = preload("res://Scenes/BulletUI.tscn")
var BulletProp = preload("res://Scenes/BulletProp.tscn")
var totalCars = 0
var totalEnemies = 0
var upgrades
var player

@export var policeLabel: Label
@export var carLabel: Label
@export var upgradesContainer: HBoxContainer

var upgDecRec = "res://Assets/Upgrades/decr_recoil.png"
var upgDecRel = "res://Assets/Upgrades/decr_reload.png"
var upgHomBul = "res://Assets/Upgrades/homing_bullet.png"
var upgIncSpe = "res://Assets/Upgrades/incr_bullet_speed.png"
var upgIncAmm = "res://Assets/Upgrades/incr_ammo_count.png"
var upgIncRec = "res://Assets/Upgrades/incr_recoil.png"
var upgIncHea = "res://Assets/Upgrades/incr_max_health.png"

var upgradeToImage = {
	"increase_recoil": upgIncRec,
	"decrease_recoil": upgDecRec,
	"increase_ammo_capacity": upgIncAmm,
	"reduce_reload_time": upgDecRel,
	"increase_health": upgIncHea,
	"homing": upgHomBul,
	"increase_bullet_speed": upgIncSpe
}

func _ready() -> void:
	await getBulletPos()
	$Mag.frame = ammo_count
	player = get_parent().get_parent().get_parent().get_node("Player")
	maxAmmo = player.maxAmmo
	ammo_count = maxAmmo
	reload_inst_bullets()

func getBulletPos() -> void: 
	for pos in bulletOffsets:
		bulletPositions.append($Mag.position-magOff+pos)
	ejectPosition = $Mag.position + ejectPosition
		
	
func _on_rigid_body_2d_ammo_count_changed(new_ammo_count: Variant) -> void:
	if maxAmmo != null:
		if ammo_count < new_ammo_count:
			reload_anim() #Calls reload animation
			reload_inst_bullets() #Reinstantiate the bullet objects in the magazine for animation
		else:
			if new_ammo_count != maxAmmo:
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
		#print(randomImpulse)
		bulletPropInstance.apply_central_impulse(Vector2(randomImpulse.x, randomImpulse.y))
		bulletPropInstance.apply_torque(randomImpulse.z)

func randomEject() -> Vector3:
	return Vector3(randi_range(-100, 20), randi_range(-150, 0), randi_range(10000,50000 ))

func increasePolice() -> void:
	totalEnemies += 1
	policeLabel.text = ": " + str(totalEnemies) + "x"

func instCars(cars:int) -> void:
	totalCars = cars
	carLabel.text = ": " + str(cars) + "x"

func decreasePolice() -> void:
	totalEnemies -= 1
	policeLabel.text = ": " + str(totalEnemies) + "x"

func decreaseCars() -> void:
	totalCars -= 1
	carLabel.text = ": " + str(totalCars) + "x"

	
func addToUpgrades(upgrade: String) -> void:
	print(upgrade)
	var upgradeObj = TextureRect.new() 
	var image = Image.load_from_file(upgradeToImage.get(upgrade))
	var imageObj = ImageTexture.new()
	imageObj.set_image(image) 
	upgradeObj.texture = imageObj
	print(upgradeObj)
	upgradesContainer.add_child(upgradeObj)
	
	
