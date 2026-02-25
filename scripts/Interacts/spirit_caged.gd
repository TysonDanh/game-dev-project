extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable: Area2D = $Interactable



func _ready() -> void:
	interactable.interact = _on_interact
	animated_sprite_2d.visible = false
	
	
func _on_interact():
	sprite_2d.visible = false
	
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("break_cage")
	
	
