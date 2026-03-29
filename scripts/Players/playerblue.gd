extends CharacterBody2D

@onready var animated_Sprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var audioJumping = $"AudioStreamPlayer - Jumping"


@export var walk_speed = 650.0
@export_range(0, 1) var acceleration = 0.15
@export_range(0, 1) var deceleration = 0.15

@export var jump_force = -700.0
@export_range (0, 1) var jump_deceleration = 0.3

# Inventory
@export var inv: Inv

var spirit_counter = 0

var is_breaking := false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	# Handle jump.
	if Input.is_action_just_pressed("jump_blue") and is_on_floor():
		velocity.y = jump_force
		audioJumping.play()
	
	if Input.is_action_just_released("jump_blue") and velocity.y < 0:
		velocity.y *= jump_deceleration
	
	
	
	#Walking Movement
	var speed = walk_speed
	var direction := Input.get_axis("left_blue", "right_blue")
	var last_direction: String = "right"
	
	if direction != 0:
		velocity.x = direction * speed
		if direction < 0:
			animated_Sprite2D.flip_h = true
			last_direction = "left"
		else:
			animated_Sprite2D.flip_h = false
			last_direction = "right"
	
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	
	move_and_slide()
	
	
	if is_breaking:
		return
	
	
	#Run Animations
	if not is_on_floor():
		if velocity.y < 0:
			if $AnimatedSprite2D.animation != "jump_up":
				$AnimatedSprite2D.play("jump_up")
		else:
			if $AnimatedSprite2D.animation != "jump_down":
				$AnimatedSprite2D.play("jump_down")
				
	
	elif direction != 0:
		$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Idle")


#Inventory stuff
func collect(item: InvItem):
	return inv.insert(item)

func remove(_index: int):
	return inv.drop()
