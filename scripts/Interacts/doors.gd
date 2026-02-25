extends Area2D

@onready var interactable: Area2D = $Interactable
@onready var animated_Sprite2D: AnimatedSprite2D = $AnimatedSprite2D

var door_open := false

func _ready() -> void:
	interactable.interact = _on_interact
	
func _on_interact():
		toggle_level()
		
func toggle_level():
	if door_open:
		return
	door_open = true
	animated_Sprite2D.play("Opening")
	await animated_Sprite2D.animation_finished
	animated_Sprite2D.play("Opened")
