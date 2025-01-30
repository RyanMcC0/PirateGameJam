extends Node2D
var level = 1
var enemyCount = 0
var playerEntrancePos = Vector2(138,613)
@export var upgradeScreen: CanvasLayer
@export var player: RigidBody2D
@export var UI: Node2D
@export var fadeInAnim: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fadeInAnim.play("fadeIn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func level_clear_check() -> void:
	if $Testlvl.spawnerCount == 0 && enemyCount == 0:
		$Player.activate_arrow()
		upgradeScreen.show_upgrade_screen(player, UI)
		$Testlvl.levelOver
func on_level_start() -> void:
	pass

func next_level() -> void:
	pass
