extends Area2D

@onready var interactable: Area2D = $Interactable
@onready var animated_Sprite2D: AnimatedSprite2D = $AnimatedSprite2D
@export var doors: NodePath


var lever_on := false

	
func _ready():
	interactable.interact = _on_interact
	
func _on_interact():
	if lever_on:
		return
	lever_on = true
	animated_Sprite2D.play("switch")
	var door_node = get_node(doors)
	if door_node:
		door_node.open_door()
	
