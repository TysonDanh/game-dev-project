extends Area2D

@onready var interactable: Area2D = $Interactable
@onready var animated_Sprite2D: AnimatedSprite2D = $AnimatedSprite2D

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
	get_tree().change_scene_to_file("res://scenes/Levels/tutorial_room_1.tscn")
