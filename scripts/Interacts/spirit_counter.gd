extends Control

@onready var counter_label = $NinePatchRect/spirit_counter

var saved_spirits = 0
var total_spirits = 0

func _ready():
		total_spirits = get_tree().get_nodes_in_group("spirits").size()
		update_counter()
		print("Spirits found: ", get_tree().get_nodes_in_group("spirits").size())

func spirit_saved():
		saved_spirits += 1
		update_counter()
		
func update_counter():
	counter_label.text = str(saved_spirits) + "/" + str(total_spirits)
