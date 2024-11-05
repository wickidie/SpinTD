class_name Map extends Node2D

@onready var ICON = preload("res://icon.svg")
@onready var TEST_ENEMY = preload("res://enemy/test/test_enemy.tscn")
@onready var BASIC_ENEMY = preload("res://enemy/basic/basic_enemy.tscn")
@onready var FAST_ENEMY = preload("res://enemy/fast/fast_enemy.tscn")
@onready var TANK_ENEMY = preload("res://enemy/tank/tank_enemy.tscn")
@onready var BONUS_ENEMY = preload("res://enemy/bonus/bonus_enemy.tscn")
@onready var map_path = $MapPath
@onready var wave_interval: Timer = $WaveInterval
@onready var spinner_spawn_point: Marker2D = $SpinnerSpawnPoint

var SPINNER_PATH = "res://spinner/spinner.tscn"

signal wave_finished

var wave: int = 1
var enemy_list: Array
var wave_list: Dictionary
var level_manager: LevelManager
var starting_money = 50
var starting_lives = 20
var spinner: Spinner

enum WAVE {ENEMY_TYPE, MOB_SET, MOB_INTERVAL, SET_INTERVAL}

func _enter_tree() -> void:
	print(self, " Enter")
	level_manager = get_parent()

func _ready():
	level_manager.lives = starting_lives
	wave_list = {
# 2D array concept [enemy_type, mob_set, mob_interval, set_interval]
		"1" : {
			"enemy_set" : [
				[FAST_ENEMY, 20, 0.3, 1],
				[TEST_ENEMY, 5, 0.3, 1],
				[BASIC_ENEMY, 10, 0.1, 1],
				[TANK_ENEMY, 5, 0.5, 1],
				[BONUS_ENEMY, 10, 0.2, 1]
			],
			"enemy_type" : [TEST_ENEMY, TEST_ENEMY, TEST_ENEMY, TEST_ENEMY, TEST_ENEMY],
			"mob_set" : [50, 15, 5, 3, 20],
			"spawn_interval" : [0.1, 0.1, 0.5, 0.1, 0.2],
			"set_interval" : [3, 3, 3, 3, 3]
		},
		"2" : {
			"enemy_set" : [
				[TEST_ENEMY, 10, 0.1, 3],
				[TEST_ENEMY, 10, 0.1, 3],
				[TEST_ENEMY, 10, 0.1, 3],
				[TEST_ENEMY, 10, 0.1, 3],
				[TEST_ENEMY, 10, 0.1, 3]
			],
		},
		"3" : {
			"enemy_set" : [
				[TEST_ENEMY, 10, 0.1, 3],
				[TEST_ENEMY, 10, 0.1, 3],
				[TEST_ENEMY, 10, 0.1, 3],
				[TEST_ENEMY, 10, 0.1, 3],
				[TEST_ENEMY, 10, 0.1, 3]
			],
		}
	}
	print("Number of Waves : ", wave_list.size(), "\n")
	wave_interval.start()
	pass

func spawn_unit(enemy_type):
	var enemy = enemy_type.instantiate()
	map_path.add_child(enemy)
	enemy_list.append(enemy)

func new_wave():
# 2D array implementation
	for i in range(wave_list[str(wave)]["enemy_set"].size()):
		for j in range(wave_list[str(wave)]["enemy_set"][i][WAVE.MOB_SET]):
			spawn_unit(wave_list[str(wave)]["enemy_set"][i][WAVE.ENEMY_TYPE])
			await get_tree().create_timer(wave_list[str(wave)]["enemy_set"][i][WAVE.MOB_INTERVAL]).timeout
		await get_tree().create_timer(wave_list[str(wave)]["enemy_set"][i][WAVE.SET_INTERVAL]).timeout

# 1D array implementation
	#for i in range(wave_list[str(wave)]["mob_set"].size()):
		##print("=== Start Of Set ", i+1, " ===")
		##print("Mob Set Size : ", wave_list[str(wave)]["mob_set"][i])
		##print("Mob Spawn Interval : ", wave_list[str(wave)]["spawn_interval"][i])
		#for j in range(wave_list[str(wave)]["mob_set"][i]):
			#spawn_unit(wave_list[str(wave)]["enemy_type"][i])
			#await get_tree().create_timer(wave_list[str(wave)]["spawn_interval"][i]).timeout
		##print("---End Of Set---")
		##print("\nNext Set in : ", wave_list[str(wave)]["set_interval"][i], " sec\n")
		#await get_tree().create_timer(wave_list[str(wave)]["set_interval"][i]).timeout
	#print("=== End Of Wave ", wave, " ===")
	wave += 1
	#wave_finished.emit()
	pass

func _on_wave_interval_timeout() -> void:
	for i in range(wave_list.size()):
		#print("\n=== Wave ", wave, " ===\n")
		await new_wave()
