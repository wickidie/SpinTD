class_name Player extends Node2D

@onready var TEST_TOWER: PackedScene = preload("res://tower/test_tower.tscn")
@onready var debug_text: RichTextLabel = $Debug/RichTextLabel

@onready var nine_patch_rect = $GUI/NinePatchRect
@onready var tower = $GUI/NinePatchRect/VBoxContainer/Tower
@onready var target_mode = $GUI/NinePatchRect/VBoxContainer/TargetMode
@onready var target = $GUI/NinePatchRect/VBoxContainer/Target
@onready var life = $GUI/HBoxContainer/Life
@onready var money = $GUI/HBoxContainer/Money

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

var economy: PlayerEconomy

func _ready():
	building_selected.connect(select_building)
	GameManager.player_list.append(self)
	economy = PlayerEconomy.new()
	nine_patch_rect.visible = false

func _process(_delta):
	if (is_building):
		if (is_precision_building and Input.is_action_pressed("LMB")):
			show_precision_build()
		elif (not is_precision_building):
			show_build()
		
	debug_text.text = (
		"building : " + str(building) + 
		"\nselected_building : " + str(selected_building) + 
		"\nis_building : " + str(is_building) + 
		"\nis_precision_building : " + str(is_precision_building) + 
		"\ncan_build : " + str(can_build))
	life.text = ("[center]" + "Life: " + str(GameManager.life) + "[/center]")
	money.text = ("[center]" + "Money: " + str(economy.money) + "[/center]")

func show_build():
	building.position = get_global_mouse_position()
	
func show_precision_build():
	var temp_pos = precision_start_pos + (get_global_mouse_position() - precision_current_pos) / 3
	building.position = temp_pos

func build():
	building.build_placed.emit()
	economy.money -= selected_building.build_cost
	can_build = true
	is_building = false
	building = null
	selected_building = null

func cancel_build():
	#print("Building Canceled : ", building)
	building.queue_free()
	is_building = false
	is_precision_building = false
	building = null
	
func select_building():
	if (get_global_mouse_position().x <= get_tree().root.size.x / 2):
		nine_patch_rect.anchors_preset = Control.PRESET_TOP_RIGHT
	else:
		nine_patch_rect.anchors_preset = Control.PRESET_TOP_LEFT
		
	nine_patch_rect.visible = true
	tower.text = ("[center]" + str(selected_building.tower_name) + "[/center]")
	target_mode.text = ("[center]" + str(selected_building.target_mode_string) + "[/center]")
	target.text = ("[center]" + str(selected_building.target.name) + "[/center]")

func unselect_building():
	#print("Unselect : ", selected_building)
	selected_building.unselected.emit()
	selected_building = null
	print(selected_building)
	nine_patch_rect.visible = false

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action_pressed("1") and can_build and not is_building 
	and economy.money >= 10):
		if (selected_building != null):
			selected_building.unselected.emit()
			can_build = true
			is_building = false
			building = null
			selected_building = null
		building = TEST_TOWER.instantiate()
		building.name = "Test Tower"
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
			build()
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
		unselect_building()
		
func _on_texture_button_pressed():
	if (can_build and not is_building and economy.money >= 10):
		if (selected_building != null):
			selected_building.unselected.emit()
			can_build = true
			is_building = false
			building = null
			selected_building = null
		building = TEST_TOWER.instantiate()
		building.name = "Test Tower"
		selected_building = building
		building.is_selected = true
		is_building = true
		get_parent().add_child(building)
