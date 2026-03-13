extends Node2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var rock_scene: PackedScene
@export var rock_count :=2


func _ready() -> void:
	interactable.interact = _on_interact
	

func _on_interact():
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	
	for i in  range(rock_count):
		var rock = rock_scene.instantiate() as RigidBody2D
		rock.global_position = global_position + Vector2(randf_range(-16, 16), randf_range(-16, 16))
		get_parent().add_child(rock)
		
		rock.apply_impulse(Vector2.ZERO, Vector2(randf_range(-100, 100), randf_range(-200, -50)))
		
		if rock is CanvasItem:
			rock.z_as_relative = false
			rock.z_index = 50
		
	queue_free()
