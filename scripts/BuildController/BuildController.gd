extends Node2D

@export var inv: Inv
@export var rock_item: InvItem
@export var wall_scene: PackedScene
@export var floor_scene: PackedScene
@export var grid_size: int = 16
@export var cost_rocks_wall: int = 2
@export var cost_rocks_floor: int = 2
@export var placed_path: NodePath = ^"../Placed"

@onready var placed_root: Node2D = get_node(placed_path)
@onready var ghost_holder: Node2D = $Ghost

signal building_toggle(is_on: bool)

# Types of building.
enum BuildType { WALL, FLOOR }

var selected_build: BuildType = BuildType.WALL
var ghost: Node2D = null
var rotate_steps: int = 0
var build_active: bool = false

# Store snapped WORLD position here and always place using this as reference.
var snapped_world_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	return

func _process(_delta: float) -> void:
	_update_ghost()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		# Select Wall
		if event.keycode == KEY_1:
			_select_build(BuildType.WALL)
			emit_signal("building_toggle", true)
		# Select Floor
		if event.keycode == KEY_2:
			emit_signal("building_toggle", true)
			_select_build(BuildType.FLOOR)
		# Rotate with R
		if event.keycode == KEY_R:
			rotate_steps = (rotate_steps + 1) % 4
	# Place and rotate with Mouse 1 & Mouse 2
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_try_place()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			rotate_steps = (rotate_steps + 1) % 4
# Here this needs to set building in player_red to false
func _select_build(t: BuildType) -> void:
	# If pressing the same build type again, toggle OFF
	if build_active and selected_build == t:
		build_active = false
		_clear_ghost()
		return
	
	selected_build = t
	build_active = true
	rotate_steps = 0
	_refresh_ghost()

func _refresh_ghost() -> void:
	if ghost:
		ghost.queue_free()
		ghost = null
	# sets ghost to wall or floor
	var scene := _get_selected_scene()
	if scene == null:
		return

	ghost = scene.instantiate() as Node2D
	ghost_holder.add_child(ghost)

# Disable interaction on ghost
	var interact := ghost.find_child("Interactable", true, false)
	if interact:
		interact.queue_free()
		
	var collision := ghost.find_child("CollisionShape2D", true, false)
	if collision:
		collision.queue_free() 

	# Ghost appearance + bring to front
	_force_render(ghost, 50, 0.35)

func _update_ghost() -> void:
	
	if not build_active or ghost == null:
		return

	# ALWAYS get mouse in WORLD 
	var mouse_world := _get_mouse_world_pos()
	snapped_world_pos = _snap_to_grid(mouse_world, grid_size)

	ghost.global_position = snapped_world_pos
	ghost.global_rotation = deg_to_rad(rotate_steps * 90.0)

	# Tint red if you can't afford
	var can_afford := (inv != null and rock_item != null and _count_rocks() >= _get_selected_cost())
	_force_modulate(ghost, Color(1, 1, 1, 0.35) if can_afford else Color(1, 0.4, 0.4, 0.35))

func _try_place() -> void:
	if inv == null or rock_item == null or ghost == null:
		return
	
	var cost := _get_selected_cost()
	if _count_rocks() < cost:
		return
	
	if not _spend_rocks(cost):
		return
	
	var scene := _get_selected_scene()
	if scene == null:
		return
	
	var placed := scene.instantiate() as Node2D
	placed_root.add_child(placed)
	
	# Place using world position.
	placed.global_position = snapped_world_pos
	placed.global_rotation = ghost.global_rotation
		
	# Visible + bring to front
	_force_render(placed, 40, 1.0)
	
	# Debug (remove later)
	print("Placed at:", placed.global_position, " ghost at:", ghost.global_position, " snapped:", snapped_world_pos)
	if _count_rocks() < _get_selected_cost():
		build_active = false
		_clear_ghost()

func _get_selected_scene() -> PackedScene:
	return wall_scene if selected_build == BuildType.WALL else floor_scene

func _get_selected_cost() -> int:
	return cost_rocks_wall if selected_build == BuildType.WALL else cost_rocks_floor

func _count_rocks() -> int:
	var total := 0
	for s in inv.slots:
		if s.item == rock_item:
			total += s.amount
	return total

func _spend_rocks(amount: int) -> bool:
	if _count_rocks() < amount:
		return false

	var remaining := amount
	for i in range(inv.slots.size()):
		if remaining <= 0:
			break

		var slot := inv.slots[i]
		if slot.item != rock_item or slot.amount <= 0:
			continue

		var take: int = min(slot.amount, remaining)
		var new_slot := slot.duplicate()
		new_slot.amount -= take
		remaining -= take

		if new_slot.amount <= 0:
			new_slot.item = null
			new_slot.amount = 0

		inv.slots[i] = new_slot

	inv.update.emit()
	return true

func _snap_to_grid(pos: Vector2, grid: int) -> Vector2:
	var g: int = max(grid, 1)
	return Vector2(
		round(pos.x / g) * g,
		round(pos.y / g) * g
	)

# WORLD mouse position 
func _get_mouse_world_pos() -> Vector2:
	var vp := get_viewport()
	var mouse_screen: Vector2 = vp.get_mouse_position()

	var cam := vp.get_camera_2d()
	if cam == null:
		# fallback to get mouse position.
		return get_global_mouse_position()

	# Convert screen to world using camera canvas transform
	return cam.get_canvas_transform().affine_inverse() * mouse_screen

# Render the object and bring forward.
func _force_render(n: Node, z: int, alpha: float) -> void:
	var safe_z := clampi(z, -100, 100)
	if n is CanvasItem:
		var ci := n as CanvasItem
		ci.visible = true
		ci.z_as_relative = false
		ci.z_index = safe_z
		ci.modulate.a = alpha
	for c in n.get_children():
		_force_render(c, safe_z, alpha)

# Colour tile piece.
func _force_modulate(n: Node, color: Color) -> void:
	if n is CanvasItem:
		(n as CanvasItem).modulate = color
	for c in n.get_children():
		_force_modulate(c, color)

# Remove ghost from view.
func _clear_ghost() -> void:
	if ghost:
		ghost.queue_free()
		ghost = null
	emit_signal("building_toggle", false)
