#The floor that guides the players placement of platforms
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	ghostfloor()

func ghostfloor():
	sprite.modulate = Color(1, 1, 0, 0.3)
 
