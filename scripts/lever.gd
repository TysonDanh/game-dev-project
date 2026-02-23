extends Area2D

@onready var interactable: Area2D = $Interactable
@onready var animated_Sprite2D: AnimatedSprite2D = $AnimatedSprite2D

var lever_on := false

func _ready() -> void:
	interactable.interact = _on_interact
	
func _on_interact():
		toggle_level()
		print("interacted")
		
func toggle_level():
	if lever_on:
		return
	lever_on = true
	animated_Sprite2D.play("switch")
	animated_Sprite2D.play("on")
	
