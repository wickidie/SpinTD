class_name LevelMenuUI extends Control

var LEVEL_SELECTION_PATH = "res://menu/level_selection.tscn"
var MAIN_MENU_PATH = "res://menu/main_menu.tscn"

@onready var level_manager: LevelManager = get_parent()

func _ready() -> void:
	visible = false

func open_menu():
	visible = !visible
	get_tree().paused = true


func close_menu():
	visible = !visible
	if (level_manager.is_game_over):
		get_tree().paused = true
	else:
		get_tree().paused = false


func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action_pressed("esc")):
		if (visible):
			close_menu()
		else:
			open_menu()

func _on_select_level_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		var LEVEL_SELECTION = load(LEVEL_SELECTION_PATH)
		get_tree().change_scene_to_packed(LEVEL_SELECTION)
		get_parent().queue_free()
		get_tree().paused = false

func _on_restart_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		get_parent().restart_game()
		get_tree().paused = false

func _on_main_menu_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		var MAIN_MENU = load(MAIN_MENU_PATH)
		get_tree().change_scene_to_packed(MAIN_MENU)
		get_parent().queue_free()
		get_tree().paused = false
