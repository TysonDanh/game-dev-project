extends CharacterBody2D


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

var is_dashing = false
var dash_start_position = 0
var dash_direction = 0
var dash_timer = 0

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
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
		
	#DASH Activation
	if Input.is_action_just_pressed("dash") and direction and not is_dashing and dash_timer <= 0:
		is_dashing = true
		dash_start_position = position.x
		dash_direction = direction
		dash_timer = dash_cooldown
		
	#Performs the actual Dashing 
	if is_dashing:
		var current_distance =abs(position.x - dash_start_position)
		if current_distance >= dash_max_distance:
			is_dashing = false
		else:
			velocity.x = dash_direction * dash_speed + dash_curve.sample(current_distance / dash_max_distance)
			velocity.y = 0
	
	#Dash timer
	if dash_timer > 0:
		dash_timer -= delta
		
		
	move_and_slide()

func collect(item: InvItem):
	return inv.insert(item)

func remove(_index: int):
	return inv.drop()
