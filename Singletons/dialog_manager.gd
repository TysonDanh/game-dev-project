extends Node

@onready var text_box_scene = preload("res://UI/textbox.tscn")

class PlayerDialogConfig:
	var node: Node2D
	var height: float
	var scene: PackedScene

	func _init(p_node: Node2D, p_height: float, p_scene: PackedScene):
		node = p_node
		height = p_height
		scene = p_scene

var dialog_lines: Array = []
var dialog_speakers: Array = []
var dialog_heights: Array = []
var dialog_nodes: Array = []
var dialog_configs: Array = []   
var current_line_index = 0
var text_box
var is_dialog_active = false
var can_advance_line = false

func _ready() -> void:
	get_tree().node_removed.connect(_on_node_removed)

func _on_node_removed(node: Node) -> void:
	if text_box != null and not is_instance_valid(text_box):
		_end()

func start_dialog(position: Vector2, lines: Array, p_npc_height: float = 64.0):
	if is_dialog_active:
		return
	var positions = []
	var heights = []
	var configs = []
	for i in lines.size():
		positions.append(position)
		heights.append(p_npc_height)
		configs.append(null)  
	_begin(lines, positions, heights, configs)


func start_conversation(
	lines: Array[String],
	config_a: PlayerDialogConfig,
	config_b: PlayerDialogConfig
):
	if is_dialog_active:
		return
	var positions = []
	var heights = []
	var configs = []
	for i in lines.size():
		var cfg = config_a if i % 2 == 0 else config_b
		positions.append(cfg.node.global_position)
		heights.append(cfg.height)
		configs.append(cfg)
	_begin(lines, positions, heights, configs)

func _begin(lines: Array[String], positions: Array, heights: Array, configs: Array):
	dialog_lines = lines.duplicate()
	dialog_speakers = positions.duplicate()
	dialog_heights = heights.duplicate()
	dialog_configs = configs.duplicate()
	current_line_index = 0
	is_dialog_active = true
	can_advance_line = false
	_show_text_box()

func _show_text_box():
	var cfg = dialog_configs[current_line_index]
	if cfg != null:
		if cfg.node == null or not is_instance_valid(cfg.node):
			_end()
			return
		text_box = cfg.scene.instantiate()
		text_box.finished_displaying.connect(_on_text_box_finished_displaying)
		get_tree().root.add_child(text_box)
		text_box.setup(cfg.node, cfg.height)
	else:
		text_box = text_box_scene.instantiate()
		text_box.finished_displaying.connect(_on_text_box_finished_displaying)
		get_tree().root.add_child(text_box)
		var pos = dialog_speakers[current_line_index]
		var h = dialog_heights[current_line_index]
		text_box.global_position = pos + Vector2(0, -h / 2.0)
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true

func _unhandled_input(event):
	if (
		event.is_action_pressed("advance_dialog") &&
		is_dialog_active &&
		can_advance_line
	):
		if text_box != null and is_instance_valid(text_box):
			text_box.queue_free()
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			_end()
			return
		_show_text_box()

func advance_dialog():
	if not is_dialog_active:
		return
		
	current_line_index += 1
	
	if current_line_index >= dialog_lines.size():
		_end()
		return
	
	_show_text_box()


func dialog_finished():
	_end()
	
func _end():
	is_dialog_active = false
	current_line_index = 0
	dialog_lines.clear()
	dialog_speakers.clear()
	dialog_heights.clear()
	dialog_configs.clear()
	if text_box != null and is_instance_valid(text_box):
		text_box.queue_free()
	text_box = null
