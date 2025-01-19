extends Control

#Resumes game by unpausing
func resume():
	get_tree().paused = false #sets pause to false
	$AnimationPlayer.play_backwards("blur") #plays blur animation in reverse

#pauses the game
func pause():
	get_tree().paused = true #sets pause to true
	$AnimationPlayer.play("blur") #plays blur animation

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
	get_tree().change_scene_to_file("res://Scenes/baseScene.tscn")


func _process(delta):
	testESC()
