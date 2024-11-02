extends Node2D

@onready var play: RichTextLabel = $GUI/VBoxContainer/Play
@onready var settings: RichTextLabel = $GUI/VBoxContainer/Settings
@onready var exit: RichTextLabel = $GUI/VBoxContainer/Exit

var LEVEL_SELECTION_path = "res://menu/level_selection.tscn"

func _ready() -> void:

	pass

func _on_play_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		var LEVEL_SELECTION = load(LEVEL_SELECTION_path)
		get_tree().change_scene_to_packed(LEVEL_SELECTION)
		print(event)
	pass # Replace with function body.


func _on_settings_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		print(event)
	pass # Replace with function body.


func _on_exit_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		print(event)
	pass # Replace with function body.
