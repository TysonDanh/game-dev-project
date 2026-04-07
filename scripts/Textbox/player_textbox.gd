extends MarginContainer
@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

var auto_close_timer = Timer.new()
const MAX_WIDTH = 256

var text = ""
var letter_index = 0
var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2
var follow_target: Node2D = null
var target_height: float = 100

signal finished_displaying()

#Runs the timer, when timer ends delete dialog
func _ready():
	timer.timeout.connect(_on_letter_display_timer_timeout)
	auto_close_timer.one_shot = true
	auto_close_timer.wait_time = 3.0
	auto_close_timer.timeout.connect(_on_auto_close_timeout)
	add_child(auto_close_timer)

#Textbox follows the player as it is active
func _process(_delta):
	if is_instance_valid(follow_target):
		var target_pos = follow_target.global_position + Vector2(0, -target_height / 2.0)
		target_pos.x -= size.x / 4.5
		target_pos.y -= size.y + 125.0
		global_position = lerp(global_position, target_pos, 0.2)


func setup(target: Node2D, height: float):
	follow_target = target
	target_height = height

#resets if there is other dialog
func display_text(text_to_display: String):
	text = text_to_display
	letter_index = 0
	timer.stop()
	auto_close_timer.stop()
	hide()
	
	#Setup the textbox
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.custom_minimum_size.x = MAX_WIDTH
	label.text = ""
	
	#waits a few frames to set up properly
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	#Places the initial textbox above player and starts typing out dialog
	if is_instance_valid(follow_target):
		var target_pos = follow_target.global_position + Vector2(0, -target_height / 2.0)
		target_pos.x -= size.x / 2.0
		target_pos.y -= size.y + 8.0
		global_position = target_pos
	label.text = ""
	await get_tree().process_frame
	show()
	_display_letter()
	

#dialog will type out instead of instantly pop in
func _display_letter():
	if letter_index >= text.length():
		finished_displaying.emit()
		auto_close_timer.start()
		return
		
	label.text += text[letter_index]
	letter_index += 1
	
	if letter_index >= text.length():
		finished_displaying.emit()
		auto_close_timer.start()
		return
		
	var next_char = text[letter_index]
	match next_char:
		"!", ".", ",", "?", ":", ";":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)


func _on_letter_display_timer_timeout() -> void:
	_display_letter()

func _on_auto_close_timeout():
	DialogManager.advance_dialog()
	queue_free()
	
