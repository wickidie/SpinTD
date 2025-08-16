class_name LevelManager extends Node2D

signal lives_damaged

var LEVEL_MENU_UI_PATH: String = "res://map/level_menu_ui.tscn"
var MAP_PATH: String
var PLAYER_PATH: String

var level: Node2D
var map: Map
var player: Player
var lives: int
var level_menu_ui: LevelMenuUI
var is_game_over: bool
var is_game_paused: bool

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action_pressed("spacebar")):
		if (is_game_paused):
			unpause_game()
			map.start_game.emit()
		else:
			change_game_speed()

func setup_game(MAP_PATH: String, PLAYER_PATH: String) -> void:
	print(map)
	print(player)
	self.MAP_PATH = MAP_PATH
	self.PLAYER_PATH = PLAYER_PATH
	map = load(MAP_PATH).instantiate()
	player = load(PLAYER_PATH).instantiate()
	level_menu_ui = load(LEVEL_MENU_UI_PATH).instantiate()
	add_child(level_menu_ui)
	add_child(map)
	add_child(player)
	if (not lives_damaged.is_connected(_on_lives_damaged)):
		lives_damaged.connect(_on_lives_damaged)
	await map.ready
	await player.ready
	is_game_paused = true
	player.game_speed.text = ("Speed: Paused")

func restart_game() -> void:
	for child in get_children():
		child.queue_free()
	setup_game(MAP_PATH, PLAYER_PATH)
	print(str(self) + "Restarted")
	is_game_paused = true
	player.game_speed.text = ("Speed: Paused")
	Engine.time_scale = 1
	
func pause_game() -> void:
	get_tree().paused = true
	is_game_paused = true
	player.game_speed.text = ("Speed: Paused")
	
func unpause_game() -> void:
	get_tree().paused = false
	is_game_paused = false
	player.game_speed.text = ("Speed: " + str(Engine.time_scale))
	
func change_game_speed() -> void:
	if (Engine.time_scale == 1):
		Engine.time_scale = 2
	else:
		Engine.time_scale = 1
	player.game_speed.text = ("Speed: " + str(Engine.time_scale))

func _on_lives_damaged() -> void:
	if (lives <= 0):
		print("Game over bro u suck")
		#is_game_over = true
		#level_menu_ui.open_menu()
	else:		
		print("Oi open ur eye, the enemy is damaging u")
