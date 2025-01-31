extends Control

@onready var start_game_card = $VBoxContainer/StartGameCard
@onready var options_card = $VBoxContainer/OptionsCard
@onready var quit_card = $VBoxContainer/QuitCard


func _ready():
	start_game_card.pressed.connect(_on_start_game_card_pressed)
	options_card.pressed.connect(_on_options_card_pressed)
	quit_card.pressed.connect(_on_quit_card_pressed)
	

func _on_start_game_card_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/baseScene.tscn")  # Change to your game scene


func _on_options_card_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/OptionsMenu.tscn")


func _on_quit_card_pressed() -> void:
	get_tree().quit()


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
