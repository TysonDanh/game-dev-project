extends Node




func _on_Next_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/credits2.tscn")
	pass # Replace with function body.


func _on_Back_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/credits1.tscn")
	pass # Replace with function body.


func _on_Menu_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/TitleScreen.tscn")
	pass # Replace with function body.
