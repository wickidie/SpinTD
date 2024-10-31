extends Node

signal life_setted(new_life)

@onready var MAP = preload("res://map/cricle_map.tscn")

var life: int
var map: Map
var player: Player

func _ready():
	map =  MAP.instantiate()
	#add_child(map)
	player = Player.new()
	life_setted.connect(set_life)
	life = 100

func set_life(new_life: int):
	life = new_life
	if (life <= 0):
		print("Game Over")
