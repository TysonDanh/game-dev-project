extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable: Area2D = $Interactable

@export var lines: Array[String] = [
	"Hello, testing dialog",
	"Same test, other NPC here"
]

func _ready() -> void:
	interactable.interact = _on_interact
	animated_sprite_2d.play("idle")
	
	
func _on_interact():
	DialogManager.start_dialog(global_position, lines)
	
