class_name LevelManager extends Node2D

signal lives_damaged

var LEVEL_MENU_UI_PATH = "res://map/level_menu_ui.tscn"
var MAP_PATH
var PLAYER_PATH

var level: Node2D
var map: Map
var player: Player
var lives
var level_menu_ui: LevelMenuUI
var is_game_over: bool

func setup_game(MAP_PATH, PLAYER_PATH):
	self.MAP_PATH = MAP_PATH
	self.PLAYER_PATH = PLAYER_PATH
	map = load(MAP_PATH).instantiate()
	player = load(PLAYER_PATH).instantiate()
	level_menu_ui = load(LEVEL_MENU_UI_PATH).instantiate()
	add_child(level_menu_ui)
	add_child(map)
	add_child(player)
	lives_damaged.connect(_on_lives_damaged)

func restart_game():
	for child in get_children():
		child.queue_free()
	setup_game(MAP_PATH, PLAYER_PATH)

func _on_lives_damaged():
	if (lives <= 0):
		print("Game over bro u suck")
		is_game_over = true
		level_menu_ui.open_menu()
	else:
		print("Oi open ur eye, the enemy is damaging u")
