extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable: Area2D = $Interactable

@export var lines: Array[String] = [
	#Lines for 1-0, first NPC
	"Who are you? How did you get into the Temple?",
	"Oh forget that now- please help me save that poor spirit!",
	"We need the key to open the cage.",
	"Maybe you could use some materials to find a way to jump up!",
	#Lines for 1-0, second NPC
	"Oh, thank you! Thank you! That was admirable!",
	"Your incredible talents could help us around here.",
	"Please, meet me outside the temple so I can explain further!",
	"Go to the door at the end of the room, use the lever to open it.",
	#Lines for 1-1, First NPC
	"Our home is under attack by a strange creature you see.",
	"Locking all of our spirits.",
	"Your guy's power to manipulate the rocks will greatly help us.",
	"Please continue to help us",
	#Lines for 1-1, Second NPC
	"Please don't that spirit fall in the pit!",
	#Lines for 1-1, Third NPC
	"There's another one under the vines, please help!",
	#Lines for 1-1, Fourth NPC
	"Thank you for savings all of our spirits!",
	"The creature is leaving a real mess of things.",
	"Trapping spirits and just leaving the key around anywhere.",
	"Please go through the door there is more spirits that needs to be saved!",
	#Lines for 1-2 First NPC
	"Hey! Before you continue, there is a button up ahead above us, it may be useful to you",
	"But also please make sure to safe the spirit below us!"
]

func _ready() -> void:
	interactable.interact = _on_interact
	animated_sprite_2d.play("idle")
	
	
func _on_interact():
	DialogManager.start_dialog(global_position, lines)
	
