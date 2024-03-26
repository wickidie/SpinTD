extends Node2D

@onready var map_path = $MapPath
@onready var ICON = preload("res://icon.svg")
@onready var TEST_ENEMY = preload("res://enemy/test_enemy.tscn")

var enemy_list: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(200):
		spawn_unit()
		await get_tree().create_timer(0.2).timeout
	pass

func _process(delta):
	pass

func spawn_unit():
	var enemy = TEST_ENEMY.instantiate()
	map_path.add_child(enemy)
	enemy_list.append(enemy)
