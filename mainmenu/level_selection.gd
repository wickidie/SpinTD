class_name LevelSelection extends Node2D

const LEVEL_MANAGER: PackedScene  = preload("res://map/level_manager.tscn")
const CRICLE_MAP: PackedScene = preload("res://map/cricle_map.tscn")
const PLAYER: PackedScene  = preload("res://player/player.tscn")

var current_level

func _on_level_1_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		change_to_level(CRICLE_MAP)
		print(event)
	pass # Replace with function body.

func change_to_level(LEVEL_SCENE: PackedScene):
	current_level = LEVEL_MANAGER.instantiate()
	current_level.setup_game(LEVEL_SCENE, PLAYER)
	get_parent().add_child(current_level)
	queue_free()
