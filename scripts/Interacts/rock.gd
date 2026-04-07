#Interactable Rock
extends RigidBody2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var item: InvItem

func _ready() -> void:
	interactable.interact = _on_interact
	
func _on_interact():
	var players = get_tree().get_nodes_in_group("players")
	for p in players:
		if p.has_method("collect"):
			var added = p.collect(item)
			if added:
				$Sprite2D.visible = false
				$CollisionShape2D.disabled = true
				queue_free()
			else:
				print("inv full")
