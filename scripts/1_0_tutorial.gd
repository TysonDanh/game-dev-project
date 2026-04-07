#Used for handling the dialogs on level 1-0 Tutorial level
extends Node2D

@export var character_a: Node2D
@export var character_b: Node2D
@export var checkpoint_x: float = 800.0

@onready var audioMusicBG = $"AudioStreamPlayer - BGMusic"

var intro_done = false
var checkpoint_done = false

@export var player: Node2D
@export var checkpoint_marker: Node2D

#Plays music, await get_tree().process_frame is to wait for thinks to load
#or else it'll crash the game, then start dialog, if there is any
func _ready():
	audioMusicBG.play()
	await get_tree().process_frame
	await get_tree().process_frame
	_start_intro_dialog()

#Checks for checkpoint for new dialogs, if there is dialog play it at that checkpoint
func _process(_delta):
	if checkpoint_done or not is_instance_valid(player):
		return
	if DialogManager.is_dialog_active:
		return
	if player.global_position.x >= checkpoint_marker.global_position.x:
		checkpoint_done = true
		_start_checkpoint_dialog()
		
#Handles the intro dialog when first join in level if there is any.
#Will play back and forth, blue talking first then red or other way around
#depending how you set up char_A and char_B in inspector
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

#Handles like the intro dialog, but for checkpoints, when checkpoint is reached,
#play new dialog
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
