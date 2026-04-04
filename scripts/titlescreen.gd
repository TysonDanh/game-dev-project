extends Control


func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://scenes/Levels/1_0_tutorial.tscn")
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
	pass # void quit (exit_code: int =-1)
	
	
func _on_CreditButton_pressed():
		get_tree().change_scene_to_file("res://UI/credits1.tscn")
		pass # Replace with function body.
