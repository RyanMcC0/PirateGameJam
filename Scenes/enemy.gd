extends RigidBody2D

class_name EnemyBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bullet_hit() -> void:
	push_error("_on_bullet_hit() must be implemented by child enemy")

func move(delta) -> void:
	push_error("move() must be implemented by child enemy")

func attack(direction) -> void:
	push_error("attack() must be implemented by child enemy")
