class_name Player extends Node2D

@onready var TEST_TOWER: PackedScene = preload("res://tower/test_tower.tscn")
@onready var build_cd: Timer = $BuildCD

signal building_prepared
signal building_selected

var building: Tower
var building_pos: Vector2
var selected_building: Tower = null
var is_building: bool = false
var can_build: bool = true
var speed = 100

func _physics_process(delta):
	if (is_building):
		show_build()

func show_build():
	building.position = get_global_mouse_position()
	#building.position.x = move_toward(building.position.x, get_global_mouse_position().x, 0.16 * speed)
	#building.position.y = move_toward(building.position.y, get_global_mouse_position().y, 0.16 * speed)

func build():
	print("\nPlayer Before : ",building.can_build_here)
	await building.check_build_space()
	print("Player After : ",building.can_build_here)
	if (building.can_build_here):
		#building_pos = get_global_mouse_position()
		building.position = building.position
		building.placed.emit()
		print("Click In build() : ", building.can_build_here)
		print("Builded : ", building, "\n")
		is_building = false
		building = null
		can_build = false
		build_cd.start()

func cancel_build():
	#if (not building.can_build_here):
	building.queue_free()
	is_building = false
	building = null

func _unhandled_key_input(event: InputEvent) -> void:
	if (Input.is_action_pressed("1") and can_build):
		if (not building):
			building = TEST_TOWER.instantiate()
			building.is_selected = true
			get_parent().add_child(building)
		is_building = true
	pass

func _unhandled_input(event):
	if (event.is_action_pressed("LMB") and is_building):
		build()
		
	elif (event.is_action_pressed("RMB") and is_building):
		cancel_build()
		
	if (event.is_action_pressed("LMB") and selected_building != null):
		print("Unselect : ", selected_building)
		selected_building.unselected.emit()
		selected_building = null
	pass

func _on_build_cd_timeout():
	print("BOOM")
	can_build = true
	build_cd.stop()
	pass # Replace with function body.
