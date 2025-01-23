extends CanvasLayer

#list of all available upgrades
var upgrades = [
	{"name": "Increase Recoil", "effect": "increase recoil"},
	{"name": "Decrease Recoil", "effect": "decrease_recoil"},
	{"name": "Increase Ammo Capacity", "effect": "increase_ammo_capacity"},
	{"name": "Reduce Reload Time", "effect": "reduce_reload_time"}
]

var player = null

func _ready() -> void:
	visible = false # hide upgrade screen initially
	$HBoxContainer/Upgrade1Button.connect("pressed", Callable(self, "_on_upgrade1_pressed"))
	$HBoxContainer/Upgrade2Button.connect("pressed", Callable(self, "_on_upgrade2_pressed"))

func show_upgrade_screen(player_instance: Node) -> void:
	visible = true # show upgrade screen
	player = player_instance # set player reference

	upgrades.shuffle() 
	var chosen_upgrades = upgrades.slice(0,2) 

	#assign upgrades to button 1
	$HBoxContainer/Upgrade1Button.text = chosen_upgrades[0]["name"] #assign button 1 
	$HBoxContainer/Upgrade1Button.set_meta("effect", chosen_upgrades[0]["effect"])

	#assign upgrades to button 2
	$HBoxContainer/Upgrade2Button.text = chosen_upgrades[1]["name"] #assign button 1 
	$HBoxContainer/Upgrade2Button.set_meta("effect", chosen_upgrades[1]["effect"])

func _on_upgrade1_pressed() -> void:
	var effect = $HBoxContainer/Upgrade1Button.get_meta("effect")
	apply_upgrade(effect)
	visible = false # upgrade screen invisible after selection

func _on_upgrade2_pressed() -> void:
	var effect = $HBoxContainer/Upgrade2Button.get_meta("effect")
	apply_upgrade(effect)
	visible = false # upgrade screen invisible after selection

func apply_upgrade(effect: String) -> void:
	match effect:
		"increase_recoil":
			player.recoil_force_trans += 200
		"decrease_recoil":
			player.recoil_force_trans -= 200
		"increase_ammo_capacity":
			player.maxAmmo += 1
			player.ammoCount = player.maxAmmo
		"reduce_reload_time":
			player.reloadTime = max(player.reloadTime - 1, 0.5)
