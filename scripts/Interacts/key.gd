#Interactble Key
extends Node2D

@onready var interactable: Area2D = $Interactable
@onready var animated_Sprite2D: AnimatedSprite2D = $AnimatedSprite2D
@export var item: InvItem


func _ready() -> void:
	interactable.interact = _on_interact
	
func _on_interact():
		toggle_level()
		
func toggle_level():
	var players = get_tree().get_nodes_in_group("players")
	for p in players:
		if p.has_method("collect"):
			var added = p.collect(item)
			if added:
				animated_Sprite2D.play("key")
				$AnimatedSprite2D.visible = false
				queue_free()
