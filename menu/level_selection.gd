class_name LevelSelection extends Node2D

const LEVEL_MANAGER_PATH: String = "res://map/level_manager.tscn"
const CRICLE_MAP_PATH: String = "res://map/cricle_map.tscn"
const PLAYER_PATH: String = "res://player/player.tscn"
const MAIN_MENU_PATH: String = "res://menu/main_menu.tscn"

# Hack : not sure for this type
var level_manager: LevelManager

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action_pressed("esc")):
		get_tree().change_scene_to_file(MAIN_MENU_PATH)

func _on_level_1_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		change_to_level(CRICLE_MAP_PATH)

func change_to_level(LEVEL_SCENE_PATH: String) -> void:
	var LEVEL_MANAGER: PackedScene = load(LEVEL_MANAGER_PATH)
	level_manager = LEVEL_MANAGER.instantiate()
	level_manager.setup_game(LEVEL_SCENE_PATH, PLAYER_PATH)
	get_parent().add_child(level_manager)
	queue_free()
