#Handles the button presses for the main menu
extends Control

func _ready() -> void:
	self.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		toggle_menu()

func toggle_menu():
	self.visible = !self.visible
	get_tree().paused = self.visible

func _on_resume_pressed() -> void:
	toggle_menu()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/TitleScreen.tscn")

func _on_tutorial_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Levels/1_0_tutorial.tscn")

func _on_level_1_1_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Levels/1_1_level.tscn")

func _on_level_1_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Levels/1_2_level.tscn")
