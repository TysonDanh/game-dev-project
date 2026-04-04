extends Control

@onready var inv: Inv = preload("res://Inventory/items/playerblueinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@export var player: CharacterBody2D
var is_open = false

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
	
func _process(_delta):
			
	if Input.is_action_just_pressed("drop"):
		var removeitem = inv.drop()
		if removeitem != null:
			update_slots()
			var player = get_tree().get_first_node_in_group("players")
			if player:                
				dropitem(removeitem, player.global_position)
	
	
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
	var offset = Vector2(randf_range(-20, 20), -16)
	instance.position = position + offset
	instance.position = position
	get_tree().current_scene.add_child(instance)
