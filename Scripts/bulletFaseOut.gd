extends RigidBody2D

var fade_out_speed = 0.7  # Speed at which the sprite fades out
var invis: bool = false
var color 
var sprite

func _ready() -> void:
	sprite = $BulletUI  # Assuming the Sprite node is a direct child

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !invis:
		color = sprite.modulate
		color.a -= fade_out_speed * delta  # Decrease the alpha value
		if color.a <= 0:
			invis = true
		else:
			sprite.modulate = color  # Apply the new color with the updated alpha
