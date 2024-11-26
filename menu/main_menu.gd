extends Node2D

const SETTINGS_PATH = "res://menu/settings.tscn"

@onready var play: RichTextLabel = $GUI/VBoxContainer/Play
@onready var settings: RichTextLabel = $GUI/VBoxContainer/Settings
@onready var exit: RichTextLabel = $GUI/VBoxContainer/Exit
@onready var gui = $GUI

var LEVEL_SELECTION_PATH = "res://menu/level_selection.tscn"
var settings_panel: Settings

func _ready() -> void:
	play.connect("mouse_entered", fade_text.bind(play))
	play.connect("mouse_exited", fade_text.bind(play))
	settings.connect("mouse_entered", fade_text.bind(settings))
	settings.connect("mouse_exited", fade_text.bind(settings))
	exit.connect("mouse_entered", fade_text.bind(exit))
	exit.connect("mouse_exited", fade_text.bind(exit))
	load_settings()

func load_settings():
	settings_panel = load(SETTINGS_PATH).instantiate()
	gui.add_child(settings_panel)

func _on_play_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		var LEVEL_SELECTION = load(LEVEL_SELECTION_PATH)
		get_tree().change_scene_to_packed(LEVEL_SELECTION)

func _on_settings_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		settings_panel.visible = !settings_panel.visible

func _on_exit_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		get_tree().quit()

func fade_text(rtl: RichTextLabel):
	if (rtl.modulate.a >= 1):
		rtl.modulate = Color(1, 1, 1, 0.5)
	else:
		rtl.modulate = Color(1, 1, 1, 1)
