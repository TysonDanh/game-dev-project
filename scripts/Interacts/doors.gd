extends Area2D

@onready var interactable: Area2D = $Interactable
@onready var animated_Sprite2D: AnimatedSprite2D = $AnimatedSprite2D

# Just change the Next Level string in the Inspector editor to a new scene using the path of the scene
@export var next_level: String = "res://scenes/Levels/tutorial_room_1.tscn"


var opened = false

func _ready():
	interactable.interact = _on_interact
	$Interactable.interact_name = " "

func open_door():
	opened = true
	animated_Sprite2D.play("Opening")
	await animated_Sprite2D.animation_finished
	animated_Sprite2D.play("Opened")
	$Interactable.interact_name = "[E] Next Level"

func _on_interact():
	if not opened:
		return
		# Just change the Next Level string in the Inspector editor to a new scene using the path of the scene
	get_tree().change_scene_to_file(next_level)
