extends Node

@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var musics: Dictionary = {
	"MainMenu" : "res://map/SpinTD_circle_map.wav"
}

var is_music_settings_on: bool

func _ready():
	is_music_settings_on = true
	music_player.bus = AudioServer.get_bus_name(1)
	add_child(music_player)
	change_music_to("MainMenu")
	print(AudioServer.get_bus_name(1))

# TODO : Music too loud at first cus this loaded b4 volume change
func change_music_to(musics_name: String):
	if (is_music_settings_on):
		music_player.stream = load(musics[musics_name])
		music_player.play()

func pause_music():
	music_player.playing = false
	
func play_music():
	music_player.playing = true
