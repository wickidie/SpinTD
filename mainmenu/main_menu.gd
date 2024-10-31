extends Node2D

@onready var play: RichTextLabel = $Control/VBoxContainer/Play
@onready var settings: RichTextLabel = $Control/VBoxContainer/Settings
@onready var exit: RichTextLabel = $Control/VBoxContainer/Exit

const LEVEL_SELECTION: PackedScene = preload("res://mainmenu/level_selection.tscn")

func _ready() -> void:

	pass

func _on_play_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
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
