#Interactable for the caged spirit
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable: Area2D = $Interactable

@export var key: InvItem

func _ready() -> void:
	interactable.interact = _on_interact
	animated_sprite_2d.visible = false
	
	
func _on_interact():
	var players = get_tree().get_nodes_in_group("players")

	for p in players:
		if p.inv.has_item(key):
			p.inv.remove_item(key)

			sprite_2d.visible = false
			animated_sprite_2d.visible = true
			animated_sprite_2d.play("break_cage")

			get_tree().call_group("hud", "spirit_saved")
			interactable.is_interactable = false
			return
	
	
