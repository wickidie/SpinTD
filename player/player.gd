extends Node2D

@onready var TEST_TOWER = preload("res://tower/test_tower.tscn")

signal building_prepared

func build():
	var building = TEST_TOWER.instantiate()
	get_parent().add_child(building)
	building.position = get_global_mouse_position()

func _unhandled_key_input(event: InputEvent) -> void:
	if (Input.is_action_pressed("1")):
		print("1")
		build()
	pass
