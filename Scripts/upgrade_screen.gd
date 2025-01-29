extends CanvasLayer

#list of all available upgrades
var upgrades = [
	{"name": "Increase Player Health", "effect": "increase_player_health", "description": "Increase max health by 1"},
	{"name": "Increase Recoil", "effect": "increase recoil", "description": "Increase recoil by 20%, (Makes movement distance larger but rotational recoil higher)"},
	{"name": "Decrease Recoil", "effect": "decrease_recoil", "description": "Decrease recoil by 20%, (Makes movement distance shorter but rotational recoil lower)"},
	{"name": "Increase Ammo Capacity", "effect": "increase_ammo_capacity", "description": "Increase max ammo by 1"},
	{"name": "Reduce Reload Time", "effect": "reduce_reload_time", "description": "Reduce reload time by 25%"},
	{"name": "Homing Bullets", "effect": "enable_homing_bullets", "description": "Bullets adjust direction to home in on the nearest enemy."},
	{"name": "Increase Bullet Speed", "effect": "increase_bullet_speed", "description": "Increases bullet speed by 20%."},

]

var player = null
var ui

func _ready() -> void:
	visible = false # hide upgrade screen initially
	$HBoxContainer/Upgrade1Container/Upgrade1Button.connect("pressed", Callable(self, "_on_upgrade1_pressed"))
	$HBoxContainer/Upgrade2Container/Upgrade2Button.connect("pressed", Callable(self, "_on_upgrade2_pressed"))

func show_upgrade_screen(player_instance: Node, ui_instance: Node) -> void:
	visible = true # show upgrade screen
	player = player_instance # set player reference
	ui = ui_instance
	upgrades.shuffle() 
	var chosen_upgrades = upgrades.slice(0,2) 

	#assign upgrades to button 1
	$HBoxContainer/Upgrade1Container/Upgrade1Button.text = chosen_upgrades[0]["name"] #assign button 1 
	$HBoxContainer/Upgrade1Container/Upgrade1Button.set_meta("effect", chosen_upgrades[0]["effect"])
	$HBoxContainer/Upgrade1Container/Upgrade1Description.text = chosen_upgrades[0]["description"]  # Update description

	#assign upgrades to button 2
	$HBoxContainer/Upgrade2Container/Upgrade2Button.text = chosen_upgrades[1]["name"] #assign button 1 
	$HBoxContainer/Upgrade2Container/Upgrade2Button.set_meta("effect", chosen_upgrades[1]["effect"])
	$HBoxContainer/Upgrade2Container/Upgrade2Description.text = chosen_upgrades[1]["description"]  # Update description


func _on_upgrade1_pressed() -> void:
	var effect = $HBoxContainer/Upgrade1Container/Upgrade1Button.get_meta("effect")
	apply_upgrade(effect)
	visible = false # upgrade screen invisible after selection

func _on_upgrade2_pressed() -> void:
	var effect = $HBoxContainer/Upgrade2Container/Upgrade2Button.get_meta("effect")
	apply_upgrade(effect)
	visible = false # upgrade screen invisible after selection

func apply_upgrade(effect: String) -> void:
	match effect:
		"increase_recoil":
			player.recoil_force_trans *= 1.2
			player.recoil_force_rot *= 1.2
		"decrease_recoil":
			player.recoil_force_trans *= 0.8
			player.recoil_force_rot *= 0.8
		"increase_ammo_capacity":
			player.maxAmmo += 1
			ui.maxAmmo += 1
		"reduce_reload_time":
			player.reloadTime *= 0.75
		"increase_player_health":
			player.max_health += 1 # increase max health by 1
			player.current_health = player.max_health # set health to max (full heal)
			player.emit_signal("health_changed", player.current_health) # emit the signal
		"enable_homing_bullets":
			player.homing_enabled = true
		"increase_bullet_speed":
			player.bullet_speed *= 1.2
			player.homing_strength *= 1.2
			player.homing_range *= 1.2
