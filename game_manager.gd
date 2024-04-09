extends Node

signal life_setted(new_life)

var life: int
var map: PackedScene
var player_list: Array

func _ready():
	life_setted.connect(set_life)
	life = 100

func set_life(new_life: int):
	life = new_life
	if (life <= 0):
		print("Game Over")
