extends CharacterBody2D

@onready var animated_Sprite2D: AnimatedSprite2D = $AnimatedSprite2D

@export var walk_speed = 650.0
@export var run_speed = 600.0
@export_range(0, 1) var acceleration = 0.15
@export_range(0, 1) var deceleration = 0.15

@export var jump_force = -700.0
@export_range (0, 1) var jump_deceleration = 0.3

@export var dash_speed = 1000.0
@export var dash_max_distance = 300.0
@export var dash_curve : Curve
@export var dash_cooldown = 1.0


# Inventory
@export var inv: Inv

var spirit_counter = 0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_deceleration
		
	
		
	#RUNNING Movement
	var speed
	if Input.is_action_pressed("run"):
		speed = run_speed
		
	else:
		speed = walk_speed
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#WALKING Movement
	var direction := Input.get_axis("left", "right")
	var last_direction: String = "right"

	if direction != 0:
		velocity.x = direction * speed
		if direction < 0:
			animated_Sprite2D.flip_h = true
			last_direction = "left"
			$AnimatedSprite2D.play("Run")
			

		else:
			animated_Sprite2D.flip_h = false
			last_direction = "right"
			$AnimatedSprite2D.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		$AnimatedSprite2D.play("Idle")
	
	
		
	
		
	move_and_slide()

func collect(item: InvItem):
	return inv.insert(item)

func remove(_index: int):
	return inv.drop()
