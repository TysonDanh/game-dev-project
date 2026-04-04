extends Area2D
class_name Interactable

@export var is_breakable: bool = false
@export var interact_name: String = ""
@export var is_interactable: bool = true



var interact: Callable = func():
	pass
	
#For the break animation for Blue
signal on_break(ani_name)
	
	
