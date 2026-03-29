extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable: Area2D = $Interactable

@export var lines: Array[String] = [
	"Who are you? How did you get into the Temple?",
	"Oh forget that now- please help me save that poor spirit!",
	"We need the key to open the cage.",
	"Maybe you could use some materials to find a way to jump up!",
	"Oh, thank you! Thank you! That was admirable!",
	"Your incredible talents could help us around here.",
	"Please, meet me outside the temple so I can explain further!",
	"Go to the door at the end of the room, use the lever to open it."
]

func _ready() -> void:
	interactable.interact = _on_interact
	animated_sprite_2d.play("idle")
	
	
func _on_interact():
	DialogManager.start_dialog(global_position, lines)
	
