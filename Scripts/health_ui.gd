extends CanvasLayer

@onready var health_label = $HBoxContainer/Label #reference the label for the health 'x3,x2 etc
@onready var player = null # reference to the player node

func _ready() -> void:
	# Find the player node and connect the health_changed signal
	player = get_parent().get_parent().get_parent().get_parent().get_node("Player")  # Adjust the path to your player node
	player.connect("health_changed", Callable(self, "_update_health"))  # Use correct callable
	_update_health(player.current_health)  # Initialize the UI with current health

func _update_health(new_health: int) -> void:
	health_label.text = "x" + str(new_health) # update text label
