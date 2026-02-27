extends Control

@onready var inv: Inv = preload("res://Inventory/items/playerblueinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var is_open = false

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()
	
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
	
func _process(_delta):
	if Input.is_action_just_pressed("Inventory"):
		if is_open:
			close()
		else:
			open()
			
	if Input.is_action_just_pressed("drop"):
		var removeitem = inv.drop()
		if removeitem != null:
			update_slots()
			var player_pos = get_parent().position
			dropitem(removeitem, player_pos)
		

func open():
	self.visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
	
func dropitem(item: InvItem, position: Vector2):
	if item == null:
		return
	var rock_scene = preload("res://scenes/Breakable/rock.tscn")
	var rock_instance = rock_scene.instantiate()
	rock_instance.item = item
	rock_instance.position = position
	get_tree().current_scene.add_child(rock_instance)


	
	
