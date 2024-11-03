class_name LevelManager extends Node2D

var LEVEL_MENU_UI_PATH = "res://map/level_menu_ui.tscn"
var MAP_PATH
var PLAYER_PATH

var level: Node2D
var map: Map
var player: Player
var level_menu_ui

# TODO : fix setup and restart
func setup_game(MAP_PATH, PLAYER_PATH):
	self.MAP_PATH = MAP_PATH
	self.PLAYER_PATH = PLAYER_PATH
	map = load(MAP_PATH).instantiate()
	player = load(PLAYER_PATH).instantiate()
	level_menu_ui = load(LEVEL_MENU_UI_PATH).instantiate()
	add_child(level_menu_ui)
	add_child(map)
	add_child(player)
	
func restart_game():
	for child in get_children():
		child.queue_free()
	setup_game(MAP_PATH, PLAYER_PATH)

