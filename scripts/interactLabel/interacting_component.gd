class_name InteractionComponent
extends Node2D


@onready var interact_label: Label = $interactLabel
var current_interactions:= []
var can_interact := true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_blue") and can_interact:
		if current_interactions:
			can_interact = false
			interact_label.hide()
			
			await current_interactions[0].interact.call()
			
			can_interact = true



func _process(delta: float) -> void:
	if current_interactions and can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable:
			var key = OS.get_keycode_string(InputMap.action_get_events("interact_blue")[0].physical_keycode)
			interact_label.text = "[" + key + "] " + current_interactions[0].interact_name
			interact_label.show()
	else:
		interact_label.hide()
			
		

func _sort_by_nearest(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist
	

func _on_interact_range_area_entered(area: Area2D) -> void:
	if area in current_interactions:
		return
	current_interactions.push_back(area)
	if area.has_signal("on_break"):
		area.on_break.connect(_on_break_animation)


func _on_interact_range_area_exited(area: Area2D) -> void:
	current_interactions.erase(area)
	if area.has_signal("on_break") and area.on_break.is_connected(_on_break_animation):
		area.on_break.disconnect(_on_break_animation)
	
func _on_break_animation(anim_name: String):
	get_parent().is_breaking = true
	get_parent().get_node("AnimatedSprite2D").play(anim_name)
	get_parent().get_node("AudioStreamPlayer - Breaking Rocks").play()
	await get_parent().get_node("AnimatedSprite2D").animation_finished
	get_parent().is_breaking = false
