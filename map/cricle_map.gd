class_name Map extends Node2D

@onready var ICON: Texture2D = preload("res://icon.svg")
@onready var TEST_ENEMY: PackedScene = preload("res://enemy/test/test_enemy.tscn")
@onready var BASIC_ENEMY: PackedScene = preload("res://enemy/basic/basic_enemy.tscn")
@onready var FAST_ENEMY: PackedScene = preload("res://enemy/fast/fast_enemy.tscn")
@onready var TANK_ENEMY: PackedScene = preload("res://enemy/tank/tank_enemy.tscn")
@onready var BONUS_ENEMY: PackedScene = preload("res://enemy/bonus/bonus_enemy.tscn")
@onready var TEST_WAVES: EnemyWaves = preload("res://map/test_wave.gd").new()
@onready var EASY_WAVES: EnemyWaves = preload("res://map/easy_wave.gd").new()
@onready var map_path: Path2D = $MapPath
@onready var wave_interval: Timer = $WaveInterval
@onready var spinner_spawn_point: Marker2D = $SpinnerSpawnPoint

var SPINNER_PATH: String = "res://spinner/spinner.tscn"

signal wave_finished
signal wave_started
signal start_game

var wave: int = 1
var enemy_list: Array
var wave_list: Dictionary
var level_manager: LevelManager
var starting_money: int = 40
var starting_lives: int = 20
var spinner: Spinner

enum WAVE {ENEMY_TYPE, MOB_SET, MOB_INTERVAL, SET_INTERVAL}

func _enter_tree() -> void:
	print(self, " Enter")
	level_manager = get_parent()

func _ready() -> void:
	wave_list = TEST_WAVES.wave_list
	level_manager.lives = starting_lives
	wave_interval.timeout.connect(_on_wave_interval_timeout)
	start_game.connect(_on_start_game)
	
func spawn_unit(enemy_type: PackedScene) -> void:
	var enemy: Enemy = enemy_type.instantiate()
	map_path.add_child(enemy)
	enemy_list.append(enemy)

func new_wave() -> void:
	if (wave < wave_list.size()):
		for i in range(wave_list[str(wave)]["enemy_set"].size()):
			for j in range(wave_list[str(wave)]["enemy_set"][i][WAVE.MOB_SET]):
				await get_tree().create_timer(wave_list[str(wave)]["enemy_set"][i][WAVE.MOB_INTERVAL]).timeout
			await get_tree().create_timer(wave_list[str(wave)]["enemy_set"][i][WAVE.SET_INTERVAL]).timeout
		wave += 1
	elif (wave >= wave_list.size()):
		print("infinite round")
	else:
		print("game finish")
	wave_finished.emit()

func _on_wave_interval_timeout() -> void:
	for i in range(wave_list.size()):
		print("\n=== Wave ", wave, " ===\n")
		await new_wave()

func _on_start_game() -> void:
	wave_interval.start()
