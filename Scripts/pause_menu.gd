extends Control

func _ready() -> void:
	#ensure both pause menu and buttons are fully reset when scene loads
	set_menu_buttons_enabled(false) # disable all buttons by default
	$AnimationPlayer.stop() #stop all animations
	visible = false # hide pause menu initially

#Resumes game by unpausing
func resume():
	get_tree().paused = false #sets pause to false
	$AnimationPlayer.play_backwards("blur") #plays blur animation in reverse
	set_menu_buttons_enabled(false)
	visible = false

#pauses the game
func pause():
	get_tree().paused = true #sets pause to true
	$AnimationPlayer.play("blur") #plays blur animation
	set_menu_buttons_enabled(true)
	visible = true # show pause menu

#Handling of ESC key press
func testESC():
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause() #if Esc pressed and not already paused, pause the game
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume() #if Esc key pressed and game is paused, resume game

#resume button press - resumes game
func _on_resume_pressed() -> void:
	resume()

#quit button press - quits game
func _on_quit_pressed() -> void:
	get_tree().quit()

#restart button press - restarts game
func _on_restart_pressed() -> void:
	get_tree().paused = false # unpause game
	set_menu_buttons_enabled(false) # disable buttons
	$AnimationPlayer.stop() #stop any ongoing animations
	get_tree().change_scene_to_file("res://Scenes/baseScene.tscn") # change scene to starting scene

#enable or disable menu buttons
func set_menu_buttons_enabled(enabled: bool) -> void:
	$PanelContainer/VBoxContainer/Resume.disabled = !enabled
	$PanelContainer/VBoxContainer/Restart.disabled = !enabled
	$PanelContainer/VBoxContainer/Quit.disabled = !enabled


func _process(delta):
	testESC()
