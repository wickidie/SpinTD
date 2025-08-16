class_name EnemyWaves extends Node

var TEST_ENEMY: PackedScene
var BASIC_ENEMY: PackedScene
var FAST_ENEMY: PackedScene
var TANK_ENEMY: PackedScene
var BONUS_ENEMY: PackedScene

var wave_list: Dictionary
	
func load_enemy_scene() -> void:
	TEST_ENEMY = load("res://enemy/test/test_enemy.tscn")
	BASIC_ENEMY = load("res://enemy/basic/basic_enemy.tscn")
	FAST_ENEMY = load("res://enemy/fast/fast_enemy.tscn")
	TANK_ENEMY = load("res://enemy/tank/tank_enemy.tscn")
	BONUS_ENEMY= load("res://enemy/bonus/bonus_enemy.tscn")
