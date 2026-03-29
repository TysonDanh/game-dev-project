extends InteractionComponent

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_red") and can_interact:
		if current_interactions:
			current_interactions.sort_custom(_sort_by_nearest)
			var nearest = current_interactions[0]
			if nearest and _is_allowed(nearest):
				can_interact = false
				interact_label.hide()
				await nearest.interact.call()
				can_interact = true

func _process(_delta: float) -> void:
	if current_interactions and can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		var nearest = current_interactions[0]
		if nearest.is_interactable and _is_allowed(nearest):
			var key = OS.get_keycode_string(InputMap.action_get_events("interact_red")[0].physical_keycode)
			interact_label.text = "[" + key + "] " + nearest.interact_name
			interact_label.show()
		else:
			interact_label.hide()
	else:
		interact_label.hide()

func _on_interact_range_area_entered(area: Area2D) -> void:
	if area in current_interactions:
		return
	current_interactions.push_back(area)

func _on_interact_range_area_exited(area: Area2D) -> void:
	current_interactions.erase(area)

func _is_allowed(area: Area2D) -> bool:
	var parent = area.get_parent()
	if parent == null:
		return false
	if "is_interactable" in parent and not parent.is_interactable:
		return false
	if "is_breakable" in parent and parent.is_breakable:
		return false

	return true
