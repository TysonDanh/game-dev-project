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
	if Input.is_action_just_pressed("Inventory_blue"):
		if is_open:
			close()
		else:
			open()
			
	if Input.is_action_just_pressed("drop_blue"):
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
	
	
const DROP_SCENES: Dictionary = {
	"rock": preload("res://scenes/Breakable/rock.tscn"),
	"key": preload("res://scenes/Interacts/key.tscn")
}

func dropitem(item: InvItem, position: Vector2):
	if item == null:
		return
	if not DROP_SCENES.has(item.name):
		push_warning("No scene for: " + str(item.name))
		return
	var instance = DROP_SCENES[item.name].instantiate()
	instance.item = item
	instance.position = position
	get_tree().current_scene.add_child(instance)

	
	



	
	
