extends Node2D

@export var character_a: Node2D
@export var character_b: Node2D
@export var checkpoint_x: float = 800.0

@onready var audioMusicBG = $"AudioStreamPlayer - BGMusic"

var intro_done = false
var checkpoint_done = false

@export var player: Node2D
@export var checkpoint_marker: Node2D

func _ready():
	audioMusicBG.play()
	await get_tree().process_frame
	await get_tree().process_frame
	_start_intro_dialog()

func _process(_delta):
	if checkpoint_done or not is_instance_valid(player):
		return
	if DialogManager.is_dialog_active:
		return
	if player.global_position.x >= checkpoint_marker.global_position.x:
		checkpoint_done = true
		_start_checkpoint_dialog()
		

func _start_intro_dialog():
	if intro_done:
		return
	intro_done = true
	var config_a = DialogManager.PlayerDialogConfig.new(
		character_a, 100,
		preload("res://UI/textbox_blue.tscn")
	)
	var config_b = DialogManager.PlayerDialogConfig.new(
		character_b, 100,
		preload("res://UI/textbox_red.tscn")
	)
	var lines: Array[String] = [
		"I don't think we're still in Mars...",
		"Definitely not... what do we do now?",
	]
	DialogManager.start_conversation(lines, config_a, config_b)

func _start_checkpoint_dialog():
	var config_a = DialogManager.PlayerDialogConfig.new(
		character_a, 100,
		preload("res://UI/textbox_blue.tscn")
	)
	var config_b = DialogManager.PlayerDialogConfig.new(
		character_b, 100,
		preload("res://UI/textbox_red.tscn")
	)
	var lines: Array[String] = [
		"Let's try building a platform here to free the spirit.",
		"As long as one of us has the material on us, I can build it.",
	]
	DialogManager.start_conversation(lines, config_a, config_b)
