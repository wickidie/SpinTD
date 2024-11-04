extends Control

var LEVEL_SELECTION_PATH = "res://menu/level_selection.tscn"
var MAIN_MENU_PATH = "res://menu/main_menu.tscn"

func _ready() -> void:
	visible = false

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action_pressed("esc")):
		visible = !visible
		if (get_tree().paused == false):
			get_tree().paused = true
		else:
			get_tree().paused = false

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
