extends Area2D

@onready var interactable: Area2D = $Interactable
@onready var animated_Sprite2D: AnimatedSprite2D = $AnimatedSprite2D



func _ready() -> void:
	interactable.interact = _on_interact
	
func _on_interact(interactor):
		toggle_level()
		
func toggle_level():
	animated_Sprite2D.play("Pressed")
	
