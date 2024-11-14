class_name Settings extends Control

@onready var resolution_option = $Panel/MarginContainer/VBoxContainer2/ResolutionHBoxContainer/ResolutionOption
@onready var display_mode_option = $Panel/MarginContainer/VBoxContainer2/DisplayModeHBoxContainer/DisplayModeOption
@onready var borderless_check_box = $Panel/MarginContainer/VBoxContainer2/BorderlessHBoxContainer/BorderlessCheckBox
@onready var music_slider = $Panel/MarginContainer/VBoxContainer2/MusicHBoxContainer/MusicHBox/MusicSlider
@onready var sfx_slider = $Panel/MarginContainer/VBoxContainer2/SfxHBoxContainer/SfxHBox/SfxSlider

@onready var root_window = get_tree().root.get_window()

const RESOLUTIONS = [
	Vector2i(1920, 1080),
	Vector2i(1280, 720),
	Vector2i(640, 360)
]

func _ready():
	display_mode_option.item_selected.connect(_on_display_mode_option_item_selected)
	resolution_option.item_selected.connect(_on_resolution_option_item_selected)
	pass


func _on_display_mode_option_item_selected(index):
	root_window.mode = index
	print(index)

func _on_resolution_option_item_selected(index):
	root_window.size = RESOLUTIONS[index]
	print(index)

