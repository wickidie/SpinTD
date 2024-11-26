class_name Settings extends Control

@onready var resolution_option: OptionButton = $Panel/MarginContainer/VBoxContainer2/ResolutionHBoxContainer/ResolutionOption
@onready var display_mode_option: OptionButton = $Panel/MarginContainer/VBoxContainer2/DisplayModeHBoxContainer/DisplayModeOption
@onready var borderless_check_box: CheckBox = $Panel/MarginContainer/VBoxContainer2/BorderlessHBoxContainer/BorderlessCheckBox
@onready var music_slider: HSlider = $Panel/MarginContainer/VBoxContainer2/MusicHBoxContainer/MusicHBox/MusicSlider
@onready var sfx_slider: HSlider = $Panel/MarginContainer/VBoxContainer2/SfxHBoxContainer/SfxHBox/SfxSlider

@onready var root_window: Window = get_tree().root.get_window()

const RESOLUTIONS = [
	Vector2i(1920, 1080),
	Vector2i(1280, 720),
	Vector2i(640, 360)
]

const DISPLAY_MODES = [
	"Windowed",
	"Fullscreen",
	"Exclusive Fullscreen"
]

func _ready():
	display_mode_option.item_selected.connect(_on_display_mode_option_item_selected)
	resolution_option.item_selected.connect(_on_resolution_option_item_selected)
	borderless_check_box.toggled.connect(_on_borderless_check_box_toggled)
	fill_options_items()

func fill_options_items():
	for resolution in RESOLUTIONS:
		resolution_option.add_item(str(resolution.x) + " x " + str(resolution.y))
	for display_mode in DISPLAY_MODES:
		display_mode_option.add_item(display_mode)

func _on_display_mode_option_item_selected(index):
	print(index)
	match index:
		0 :
			root_window.mode = Window.MODE_WINDOWED
		1 :
			root_window.mode = Window.MODE_FULLSCREEN
		2 :
			root_window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
		_:
			print("Unkown Display Mode")

func _on_resolution_option_item_selected(index):
	root_window.size = RESOLUTIONS[index]
	
func _on_borderless_check_box_toggled(toggled_on):
	root_window.borderless = toggled_on
