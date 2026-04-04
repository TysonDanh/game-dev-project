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

var building := false

func _physics_process(delta: float) -> void:
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			var rock = collision.get_collider()
			rock.apply_central_force(collision.get_normal() * -50.0)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	if building:
		$AnimatedSprite2D.play("Charge")
		velocity.x = move_toward(velocity.x, 0, walk_speed)
	else:
		
		# Handle jump.
		if Input.is_action_just_pressed("jump_red") and is_on_floor():
			velocity.y = jump_force
			audioJumping.play()
		
		if Input.is_action_just_released("jump_red") and velocity.y < 0:
			velocity.y *= jump_deceleration
		
		#Walking Movement
		var speed = walk_speed
		var direction := Input.get_axis("left_red", "right_red")
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
		
		if is_breaking:
			return
		
		# Animations
		if not is_on_floor():
			if velocity.y < 0:
				if $AnimatedSprite2D.animation != "jump_up":
					$AnimatedSprite2D.play("jump_up")
			else:
				if $AnimatedSprite2D.animation != "jump_down":
					$AnimatedSprite2D.play("jump_down")
		elif direction != 0:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("Idle")

#Inventory Stuff
func collect(item: InvItem):
	return inv.insert(item)

func _ready():
	pass
	

func _on_build_controller_building_toggle(is_on: bool) -> void:
	if building != is_on:
		building = is_on
