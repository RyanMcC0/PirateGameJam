extends CanvasLayer
var color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_opacity(0.75)  # Set the UI opacity to 90%

func set_opacity(opacity: float) -> void:
	color = $Ui.modulate
	color.a = opacity  # Set the alpha value to the desired opacity
	$Ui.modulate = color  # Apply the new color with the updated alpha
