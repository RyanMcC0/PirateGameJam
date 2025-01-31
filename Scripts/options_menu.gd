extends Control

@onready var music_slider = $MusicVolumeSliderContainer/MusicVolumeSlider
@onready var game_slider = $GameVolumeSliderContainer2/GameVolumeSlider

func _ready():
	music_slider.value = get_bus_volume("Music")
	game_slider.value = get_bus_volume("SFX")
	
	music_slider.connect("value_changed", Callable(self, "_on_music_volume_changed"))
	game_slider.connect("value_changed", Callable(self, "_on_game_volume_changed"))


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_music_volume_slider_value_changed(value: float) -> void:
	set_bus_volume("Music", value)


func _on_game_volume_slider_value_changed(value: float) -> void:
	set_bus_volume("SFX", value)


func set_bus_volume(bus_name, value):
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func get_bus_volume(bus_name):
	var bus_index = AudioServer.get_bus_index(bus_name)
	return db_to_linear(AudioServer.get_bus_volume_db(bus_index))
