class_name Player extends Node2D

@onready var TEST_TOWER: PackedScene = preload("res://tower/test_tower.tscn")
@onready var build_cd: Timer = $BuildCD
@onready var debug_text: RichTextLabel = $Debug/RichTextLabel

signal building_prepared
signal building_selected

var building: Tower
var selected_building: Tower = null

var can_build: bool = true
var is_building: bool = false
var is_precision_building: bool = false

var precision_start_pos: Vector2
var precision_current_pos: Vector2

var selected_building_bool: bool
var building_bool: bool

func _process(delta):
	if (building != null):
		building_bool = true
	else:
		building_bool = false
		
	if (selected_building != null):
		selected_building_bool = true
	else:
		selected_building_bool = false
		
	if (is_building):
		if (is_precision_building and Input.is_action_pressed("LMB")):
			show_precision_build()
		elif (not is_precision_building):
			show_build()
			
	debug_text.text = (
		"building : " + str(building) + 
		"\nbuilding_bool : " + str(building_bool) +
		"\nselected_building : " + str(selected_building) + 
		"\nselected_building_bool : " + str(selected_building_bool) + 
		"\nis_building : " + str(is_building) + 
		"\nis_precision_building : " + str(is_precision_building) + 
		"\ncan_build : " + str(can_build))

func show_build():
	building.position = get_global_mouse_position()
	
func show_precision_build():
	var temp_pos = precision_start_pos + (get_global_mouse_position() - precision_current_pos) / 3
	building.position = temp_pos

func build():
	if (building.check_build_space()):
		build_cd.start()
		can_build = false
		is_building = false
		building = null
		selected_building = null
		print("Builded : ", building, "\n")

func cancel_build():
	print("Building Canceled : ", building)
	building.queue_free()
	is_building = false
	is_precision_building = false
	building = null

func _unhandled_key_input(event: InputEvent) -> void:
	if (Input.is_action_pressed("1") and can_build and not is_building):
		if (selected_building != null):
			selected_building.unselected.emit()
			can_build = false
			is_building = false
			building = null
			selected_building = null
		building = TEST_TOWER.instantiate()
		selected_building = building
		building.is_selected = true
		is_building = true
		get_parent().add_child(building)

func _unhandled_input(event):
	if (event.is_action_released("LMB") and is_building and building != null):
		if (building.can_build_here):
			if (is_precision_building):
				print("Builded Precision: ", building, "\n")
				is_precision_building = false
			else:
				print("Builded : ", building, "\n")
				
			building.build_placed.emit()
			build_cd.start()
			can_build = false
			is_building = false
			building = null
			selected_building = null
		elif (not building.can_build_here):
			is_precision_building = true
			precision_start_pos = building.position
			precision_current_pos = get_global_mouse_position()
	
	if (event.is_action_pressed("LMB") and is_building and is_precision_building and building != null):
		precision_current_pos = get_global_mouse_position()
		
# Cancel building
	elif (event.is_action_pressed("RMB") and is_building and building != null):
		cancel_build()
	
# Unselect tower
	if (event.is_action_pressed("LMB") and selected_building != null and not is_building):
		print("Unselect : ", selected_building)
		selected_building.unselected.emit()
		selected_building = null
		print(selected_building)

func _on_build_cd_timeout():
	can_build = true
	build_cd.stop()
