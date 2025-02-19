class_name Settings extends Control

@onready var resolution_option: OptionButton = $Panel/MarginContainer/VBoxContainer2/ResolutionHBoxContainer/ResolutionOption
@onready var display_mode_option: OptionButton = $Panel/MarginContainer/VBoxContainer2/DisplayModeHBoxContainer/DisplayModeOption
@onready var borderless_check_box: CheckBox = $Panel/MarginContainer/VBoxContainer2/BorderlessHBoxContainer/BorderlessCheckBox
@onready var music_slider: HSlider = $Panel/MarginContainer/VBoxContainer2/MusicHBoxContainer/MusicHBox/MusicSlider
@onready var sfx_slider: HSlider = $Panel/MarginContainer/VBoxContainer2/SfxHBoxContainer/SfxHBox/SfxSlider
@onready var music_value: LineEdit = $Panel/MarginContainer/VBoxContainer2/MusicHBoxContainer/MusicHBox/MusicValue

@onready var root_window: Window = get_tree().root.get_window()

const RESOLUTIONS: Array = [
	Vector2i(1920, 1080),
	Vector2i(1280, 720),
	Vector2i(640, 360)
]

const DISPLAY_MODES: Array = [
	"Windowed",
	"Fullscreen",
	"Exclusive Fullscreen"
]

var default_settings_value: Dictionary = {
	"resolution" = 1,
	"display_mode" = 0,
	"borderless" = false,
	"music_volume" = 0.5,
	"sfx_volume" = 0.7,
}

func _ready() -> void:
	visible = false
	display_mode_option.item_selected.connect(_on_display_mode_option_item_selected)
	resolution_option.item_selected.connect(_on_resolution_option_item_selected)
	borderless_check_box.toggled.connect(_on_borderless_check_box_toggled)
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	music_value.text_submitted.connect(_on_music_value_text_submitted)
	fill_options_items()
	
	set_default_settings_value()

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action_pressed("esc")):
		visible = false

func set_default_settings_value() -> void:
	_on_resolution_option_item_selected(default_settings_value["resolution"])
	_on_display_mode_option_item_selected(default_settings_value["display_mode"])
	_on_borderless_check_box_toggled(default_settings_value["borderless"])
	_on_music_slider_value_changed(default_settings_value["music_volume"])

func fill_options_items() -> void:
	for resolution: Vector2i in RESOLUTIONS:
		resolution_option.add_item(str(resolution.x) + " x " + str(resolution.y))
	for display_mode: String in DISPLAY_MODES:
		display_mode_option.add_item(display_mode)

func _on_display_mode_option_item_selected(index: int) -> void:
	match index:
		0 :
			root_window.mode = Window.MODE_WINDOWED
		1 :
			root_window.mode = Window.MODE_FULLSCREEN
		2 :
			root_window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
		_:
			print("Unkown Display Mode")

func _on_resolution_option_item_selected(index: int) -> void:
	root_window.size = RESOLUTIONS[index]
	
func _on_borderless_check_box_toggled(toggled_on: bool) -> void:
	root_window.borderless = toggled_on

func _on_music_slider_value_changed(value: float) -> void:
	MusicManager.music_player.volume_db = linear_to_db(value)
	music_value.text = str(value)
	music_slider.value = value
	
func _on_music_value_text_submitted(new_text: String) -> void:
	var new_float: float = float(new_text)
	print(new_float)
	if (new_float >= 1):
		new_float = 1
	elif (new_float <= 0):
		new_float = 0
	else:
		print("NAN")
	print(new_float)
	_on_music_slider_value_changed(new_float)
