extends Node2D

@onready var TEST_TOWER = preload("res://tower/test_tower.tscn")

signal building_prepared

var building
var is_building: bool = false

func _process(delta):
	if (is_building):
		show_build()

func show_build():
	building.position = get_global_mouse_position()
	
func build():
	building.position = get_global_mouse_position()
	
func cancel_build():
	building.queue_free()

func _unhandled_key_input(event: InputEvent) -> void:
	if (Input.is_action_pressed("1")):
		if (not building):
			building = TEST_TOWER.instantiate()
			get_parent().add_child(building)
		is_building = true
		
	pass
	
func _unhandled_input(event):
	if (event.is_action_pressed("LMB") and is_building and building.can_build_here):
		build()
		is_building = false
		building = null
	elif (event.is_action_pressed("RMB") and is_building):
		cancel_build()
		is_building = false
		building = null
	pass
