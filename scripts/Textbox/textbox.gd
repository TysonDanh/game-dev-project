#This handles like the player textbox but for NPC instead.
extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer
@onready var auto_close_timer = Timer.new()


const MAX_WIDTH = 256

var text = ""
var letter_index = 0
var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2
var base_position: Vector2

signal finished_displaying()

func _ready():
	timer.timeout.connect(_on_letter_display_timer_timeout)
	auto_close_timer.one_shot = true
	auto_close_timer.wait_time = 3.0
	auto_close_timer.timeout.connect(_on_auto_close_timeout)
	add_child(auto_close_timer)

func display_text(text_to_display: String):
	text = text_to_display
	letter_index = 0

	timer.stop()
	auto_close_timer.stop()

	hide()

	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.custom_minimum_size.x = MAX_WIDTH
	label.text = ""

	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame

	base_position = global_position

	label.text = ""
	await get_tree().process_frame

	show()
	_display_letter()

func _display_letter():
	if letter_index >= text.length():
		finished_displaying.emit()
		auto_close_timer.start()
		return

	label.text += text[letter_index]
	letter_index += 1

	await get_tree().process_frame

	global_position.x = base_position.x - size.x / 2.0
	global_position.y = base_position.y - size.y - 50

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
