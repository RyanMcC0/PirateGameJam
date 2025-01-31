extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.finalTime:
		$Time.text = seconds_to_timer(Globals.finalTime)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")

func seconds_to_timer(seconds: int) -> String:
	var minutes = int(seconds / 60)
	var OutSeconds = seconds % 60
	return str(minutes).pad_zeros(2) + ":" + str(OutSeconds).pad_zeros(2)
