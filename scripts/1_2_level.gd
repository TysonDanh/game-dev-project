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
