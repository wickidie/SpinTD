extends Node2D

@onready var map_path = $MapPath
@onready var ICON = preload("res://icon.svg")
@onready var TEST_ENEMY = preload("res://enemy/test_enemy.tscn")
@onready var wave_interval: Timer = $WaveInterval

signal wave_finished

var enemy_list: Array
var wave: int = 1
var wave_list = {
	"1" : {
		"mob_set" : [10, 15, 5, 3, 20],
		"spawn_interval" : [0.5, 0.1, 0.5, 0.1, 0.2],
		"set_interval" : [3, 3, 3, 3, 3]
	},
	"2" : {
		"mob_set" : [5, 10, 15, 20, 3],
		"spawn_interval" : [1, 0.1, 0.5, 0.1, 1],
		"set_interval" : [1, 1, 1, 1, 1]
	},
	"3" : {
		"mob_set" : [5, 5, 5, 5, 5],
		"spawn_interval" : [1, 2, 1, 0, 0],
		"set_interval" : [1, 1, 1, 1, 1]
	}
}
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Number of Waves : ", wave_list.size())
	wave_interval.start()
	pass

func _process(delta):
	pass

func spawn_unit():
	var enemy = TEST_ENEMY.instantiate()
	map_path.add_child(enemy)
	enemy_list.append(enemy)

func new_wave():
	for i in range(wave_list[str(wave)]["mob_set"].size()):
		#print("=== Start Of Set ", i+1, " ===")
		#print("Mob Set Size : ", wave_list[str(wave)]["mob_set"][i])
		#print("Mob Spawn Interval : ", wave_list[str(wave)]["spawn_interval"][i])
		for j in range(wave_list[str(wave)]["mob_set"][i]):
			spawn_unit()
			await get_tree().create_timer(wave_list[str(wave)]["spawn_interval"][i]).timeout
		#print("---End Of Set---")
		#print("\nNext Set in : ", wave_list[str(wave)]["set_interval"][i], " sec\n")
		await get_tree().create_timer(wave_list[str(wave)]["set_interval"][i]).timeout
	#print("=== End Of Wave ", wave, " ===")
	wave += 1
	#wave_finished.emit()
	pass

func _on_wave_interval_timeout() -> void:
	for i in range(wave_list.size()):
		#print("\n=== Wave ", wave, " ===\n")
		await new_wave()
	pass # Replace with function body.
