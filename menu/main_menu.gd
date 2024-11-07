extends Node2D

@onready var play: RichTextLabel = $GUI/VBoxContainer/Play
@onready var settings: RichTextLabel = $GUI/VBoxContainer/Settings
@onready var exit: RichTextLabel = $GUI/VBoxContainer/Exit

var LEVEL_SELECTION_PATH = "res://menu/level_selection.tscn"

func _ready() -> void:
	play.connect("mouse_entered", fade_text.bind(play))
	play.connect("mouse_exited", fade_text.bind(play))
	settings.connect("mouse_entered", fade_text.bind(settings))
	settings.connect("mouse_exited", fade_text.bind(settings))
	exit.connect("mouse_entered", fade_text.bind(exit))
	exit.connect("mouse_exited", fade_text.bind(exit))

func _on_play_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		var LEVEL_SELECTION = load(LEVEL_SELECTION_PATH)
		get_tree().change_scene_to_packed(LEVEL_SELECTION)

func _on_settings_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		print(event)

func _on_exit_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		get_tree().quit()

func fade_text(rtl: RichTextLabel):
	if (rtl.modulate.a >= 1):
		rtl.modulate = Color(1, 1, 1, 0.5)
	else:
		rtl.modulate = Color(1, 1, 1, 1)
