extends Node2D

@onready var play: RichTextLabel = $GUI/VBoxContainer/Play
@onready var settings: RichTextLabel = $GUI/VBoxContainer/Settings
@onready var exit: RichTextLabel = $GUI/VBoxContainer/Exit

var LEVEL_SELECTION_PATH = "res://menu/level_selection.tscn"

func _on_play_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		var LEVEL_SELECTION = load(LEVEL_SELECTION_PATH)
		get_tree().change_scene_to_packed(LEVEL_SELECTION)


func _on_settings_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		print(event)


func _on_exit_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		print(event)
