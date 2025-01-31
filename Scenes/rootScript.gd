extends Node2D
var level = 1
var enemyCount = 0
var playerEntrancePos = Vector2(138,613)
var levelClear
var levelChange = false
var levelScene = preload("res://Scenes/Levels/testlvl.tscn")
var time = 0

@export var upgradeScreen: CanvasLayer
@export var player: RigidBody2D
@export var UI: Node2D
@export var fadeInAnim: AnimationPlayer
@export var AudioMaster: Node
var levelObj

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_level()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta

func get_time() -> float:
	return time;

func level_clear_check() -> void:
	if levelObj.spawnerCount == 0 && enemyCount == 0:
		levelClear = true
		$Player.activate_arrow()
		upgradeScreen.show_upgrade_screen(player, UI)
		AudioMaster.get_child(1).play()
		

func on_level_start() -> void:
	self.move_child(self.get_child(-1),0)
	levelObj = get_child(0)
	$Player.current_health = $Player.max_health
	UI.get_child(2)._update_health($Player.current_health)
	fadeInAnim.play("fadeIn")
	get_tree().paused = false
	levelClear = false
	levelChange = false
	AudioMaster.get_child(0).playing = true
	if level == 6:
		get_tree().change_scene_to_file("res://Scenes/GameWinScreen.tscn")
		Globals.setFinalTime(int(time))

func on_level_end() -> void:
	fadeInAnim.play("fadeOut")
	levelChange = true
	player.hide_arrow()

func next_level() -> void:
	$Player.position = playerEntrancePos
	self.add_child(levelScene.instantiate())
	on_level_start()

func _on_fade_in_animation_finished(anim_name: StringName) -> void:
	if levelChange:
		level += 1
		get_tree().paused = true
		levelObj.queue_free()
		next_level()
