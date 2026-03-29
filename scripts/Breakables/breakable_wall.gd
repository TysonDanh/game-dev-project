extends Node2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var rock_scene: PackedScene
@export var rock_count :=2

enum InteractionType { BREAK }

@export var interaction_type: InteractionType = InteractionType.BREAK
var is_interactable := true
var is_breakable := true
var interact_name := "Break"

var interact: Callable

signal on_break(anim_name: String)


func _ready() -> void:
	interactable.interact = _on_interact
	

func _on_interact():
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	$Interactable.emit_signal("on_break", "break_wall")
	
	for i in rock_count:
		var rock = rock_scene.instantiate()
		rock.global_position = global_position + Vector2(randf_range(-16, 16), randf_range(-48, -16))
		get_parent().add_child(rock)
		
		rock.set_collision_layer_value(3, true)   
		rock.set_collision_mask_value(3, false)
		
		rock.apply_impulse(Vector2.ZERO, Vector2(randf_range(-100, 100), randf_range(-200, -50)))
		
		if rock is CanvasItem:
			rock.z_as_relative = false
			rock.z_index = 50
			
		
		queue_free()
	
