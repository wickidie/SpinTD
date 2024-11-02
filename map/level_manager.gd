class_name LevelManager extends Node2D

const LEVEL_SELECTION: PackedScene = preload("res://menu/level_selection.tscn")
const MAIN_MENU: PackedScene = preload("res://menu/main_menu.tscn")

@onready var ui: Control = $UI

var MAP: PackedScene
var PLAYER: PackedScene
var level: Node2D
var map: Map
var player: Player

func _ready() -> void:
	ui.visible = false
# TODO : fix setup and restart
func setup_game(MAP: PackedScene, PLAYER: PackedScene):
	self.MAP = MAP
	self.PLAYER = PLAYER
	map = MAP.instantiate()
	player = PLAYER.instantiate()
	level = Node2D.new()
	add_child(level)
	level.add_child(map)
	level.add_child(player)

func restart_game():
	level.queue_free()
	level = Node2D.new()
	add_child(level)
	map = MAP.instantiate()
	player = PLAYER.instantiate()
	level.add_child(map)
	level.add_child(player)

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action_pressed("esc")):
		ui.visible = !ui.visible
		if (Engine.time_scale == 0):
			Engine.time_scale = 1
		else:
			Engine.time_scale = 0

func _on_select_level_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		get_tree().change_scene_to_packed(LEVEL_SELECTION)
		queue_free()
		Engine.time_scale = 1
		print(event)
	pass # Replace with function body.

func _on_restart_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		restart_game()
		print(event)
	pass # Replace with function body.

func _on_main_menu_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		get_tree().change_scene_to_packed(MAIN_MENU)
		queue_free()
		Engine.time_scale = 1
		print(event)
	pass # Replace with function body.
