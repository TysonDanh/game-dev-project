extends Node




func _on_Next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits2.tscn")
	pass # Replace with function body.


func _on_Back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits1.tscn")
	pass # Replace with function body.


func _on_Menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")
	pass # Replace with function body.
