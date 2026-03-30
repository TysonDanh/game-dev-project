extends Camera2D

@export var Player_Red: Node2D
@export var Player_Blue: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Player_Red and Player_Blue:
		var red_pos = Player_Red.global_position
		var blue_pos = Player_Blue.global_position
		var centre = (red_pos + blue_pos) / 2
		global_position = global_position.lerp(centre, 0.1)
