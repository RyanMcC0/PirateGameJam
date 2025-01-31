extends Node2D

var spawnPoints: Array
var level
var policeSpawner = preload("res://Scenes/PoliceSpawner.tscn")
var spawnerCount = 0
var levelOver = false
@onready var root = get_tree().get_root().get_node("Node2D")
@onready var player: Node2D = get_tree().get_root().get_node("Node2D/Player")
@onready var UI: Node2D = get_tree().get_root().get_node("Node2D/Player/UI/Ui")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level = clamp(root.level,1,4)
	for spawn in get_children():
		if spawn.editor_description == "true":
			spawnPoints.append(spawn)
	spawnSpawners()
	UI.instCars(spawnerCount)

func spawnSpawners() -> void:
	spawnPoints.shuffle()
	for i in range(level):
		spawnerCount += 1
		var point = spawnPoints.pop_front()
		var position = point.global_position
		var spawner = policeSpawner.instantiate()
		spawner.position = position
		spawner.parentNode = self
		self.add_child.call_deferred(spawner)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reduce_spawners() -> void:
	print(spawnerCount)
	spawnerCount -= 1
	UI.decreaseCars()
	if spawnerCount == 0:
		root.level_clear_check()

func _on_exit_level_body_entered(body: Node2D) -> void:
	if body == player and root.levelClear:
		root.on_level_end()
