extends CanvasLayer

#list of all available upgrades
var upgrades = [
	{"name": "Increase Player Health", "effect": "increase_player_health", "description": "Increase max health by 1", "image": "res://Assets/Upgrade Cards/MORE HEALTH card.png"},
	{"name": "Increase Recoil", "effect": "increase_recoil", "description": "Increase recoil by 20%, (Makes movement distance larger)", "image": "res://Assets/Upgrade Cards/MORE RECOIL card.png"},
	{"name": "Decrease Recoil", "effect": "decrease_recoil", "description": "Decrease recoil by 20%, (Makes rotational recoil lower)", "image": "res://Assets/Upgrade Cards/LESS RECOIL card.png"},
	{"name": "Increase Ammo Capacity", "effect": "increase_ammo_capacity", "description": "Increase max ammo by 1", "image": "res://Assets/Upgrade Cards/MORE AMMO card.png"},
	{"name": "Reduce Reload Time", "effect": "reduce_reload_time", "description": "Reduce reload time by 25%", "image": "res://Assets/Upgrade Cards/FAST RELOAD card.png"},
	{"name": "Homing Bullets", "effect": "enable_homing_bullets", "description": "Bullets adjust direction to home in on the nearest enemy.", "image": "res://Assets/Upgrade Cards/HOMING BULLET UPGRADE card.png"},
	{"name": "Increase Bullet Speed", "effect": "increase_bullet_speed", "description": "Increases bullet speed by 20%.", "image": "res://Assets/Upgrade Cards/FAST BULLETS upgrade card.png"},

]

var player = null
var ui

func _ready() -> void:
	visible = false # hide upgrade screen initially
	$HBoxContainer/Upgrade1Container/Upgrade1Card.connect("pressed", Callable(self, "_on_upgrade1_pressed"))
	$HBoxContainer/Upgrade2Container/Upgrade2Card.connect("pressed", Callable(self, "_on_upgrade2_pressed"))

func show_upgrade_screen(player_instance: Node, ui_instance: Node) -> void:
	visible = true # show upgrade screen
	player = player_instance # set player reference
	ui = ui_instance
	upgrades.shuffle() 
	var chosen_upgrades = upgrades.slice(0,2) 

	#assign upgrades to button 1
	$Upgrade1Name.text = chosen_upgrades[0]["name"]
	$HBoxContainer/Upgrade1Container/Upgrade1Card.texture_normal = load(chosen_upgrades[0]["image"])
	$HBoxContainer/Upgrade1Container/Upgrade1Card.set_meta("effect", chosen_upgrades[0]["effect"])
	$Upgrade1Description.text = chosen_upgrades[0]["description"]  # Update description

	#assign upgrades to button 2
	$Upgrade2Name.text = chosen_upgrades[1]["name"]
	$HBoxContainer/Upgrade2Container/Upgrade2Card.texture_normal = load(chosen_upgrades[1]["image"])
	$HBoxContainer/Upgrade2Container/Upgrade2Card.set_meta("effect", chosen_upgrades[1]["effect"])
	$Upgrade2Description.text = chosen_upgrades[1]["description"]  # Update description


func _on_upgrade1_pressed() -> void:
	var effect = $HBoxContainer/Upgrade1Container/Upgrade1Card.get_meta("effect")
	apply_upgrade(effect)
	visible = false # upgrade screen invisible after selection
	$Upgrade.play()

func _on_upgrade2_pressed() -> void:
	var effect = $HBoxContainer/Upgrade2Container/Upgrade2Card.get_meta("effect")
	apply_upgrade(effect)
	visible = false # upgrade screen invisible after selection
	$Upgrade.play()

func apply_upgrade(effect: String) -> void:
	match effect:
		"increase_recoil":
			print("hit increc")
			player.recoil_force_trans *= 1.2
			player.upgrades.append("increase_recoil")
			ui.addToUpgrades("increase_recoil")
		"decrease_recoil":
			player.recoil_force_rot *= 0.8
			player.upgrades.append("decrease_recoil")
			ui.addToUpgrades("decrease_recoil")
		"increase_ammo_capacity":
			player.maxAmmo += 1
			ui.maxAmmo += 1
			player.upgrades.append("increase_ammo_capacity")
			ui.addToUpgrades("increase_ammo_capacity")
			if player.maxAmmo == 9:
				upgrades.pop_at(upgrades.find({"name": "Increase Ammo Capacity", "effect": "increase_ammo_capacity", "description": "Increase max ammo by 1"}))
		"reduce_reload_time":
			player.reloadTime *= 0.75
			player.upgrades.append("reduce_reload_time")
			ui.addToUpgrades("reduce_reload_time")
		"increase_player_health":
			player.max_health += 1 # increase max health by 1
			player.current_health = player.max_health # set health to max (full heal)
			player.emit_signal("health_changed", player.current_health) # emit the signal
			player.upgrades.append("increase_health")
			ui.addToUpgrades("increase_health")
		"enable_homing_bullets":
			player.homing_enabled = true
			player.upgrades.append("homing")
			ui.addToUpgrades("homing")
			upgrades.pop_at(upgrades.find({"name": "Homing Bullets", "effect": "enable_homing_bullets", "description": "Bullets adjust direction to home in on the nearest enemy."}))
		"increase_bullet_speed":
			player.bullet_speed *= 1.2
			player.homing_strength *= 1.2
			player.homing_range *= 1.2
			player.upgrades.append("increase_bullet_speed")
			ui.addToUpgrades("increase_bullet_speed")
