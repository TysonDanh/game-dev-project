extends Area2D

@onready var interactable: Area2D = $Interactable
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Parent stuff
@export var parent_collision_shape_path: NodePath
@export var parent_animated_sprite_path: NodePath
@export var parent_animation_name: String = "Open"
@export var disable_parent_collision: bool = true

var pressed = false

func _ready():
	interactable.interact = _on_interact

func _on_interact():
	if pressed:
		return
	
	pressed = true
	
	# Keep button press animation
	animated_sprite_2d.play("Pressed")
	
	# Toggle parent collision shape
	if parent_collision_shape_path != NodePath():
		var collision_shape = get_node_or_null(parent_collision_shape_path) as CollisionShape2D
		if collision_shape:
			collision_shape.disabled = disable_parent_collision
	
	# Play parent animated sprite animation
	if parent_animated_sprite_path != NodePath():
		var parent_sprite = get_node_or_null(parent_animated_sprite_path) as AnimatedSprite2D
		if parent_sprite:
			parent_sprite.play(parent_animation_name)
	
