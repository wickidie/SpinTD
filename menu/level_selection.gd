class_name LevelSelection extends Node2D

const LEVEL_MANAGER_PATH = "res://map/level_manager.tscn"
const CRICLE_MAP_PATH = "res://map/cricle_map.tscn"
const PLAYER_PATH = "res://player/player.tscn"

var current_level

func _on_level_1_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		change_to_level(CRICLE_MAP_PATH)

func change_to_level(LEVEL_SCENE_PATH):
	var LEVEL_MANAGER = load(LEVEL_MANAGER_PATH)
	current_level = LEVEL_MANAGER.instantiate()
	current_level.setup_game(LEVEL_SCENE_PATH, PLAYER_PATH)
	get_parent().add_child(current_level)
	queue_free()
