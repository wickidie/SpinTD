class_name Player extends Node2D

@onready var TEST_TOWER: PackedScene = preload("res://tower/test/test_tower.tscn")
@onready var BASIC_TOWER: PackedScene = preload("res://tower/basic/tower_basic.tscn")

@onready var debug_text: RichTextLabel = $Debug/RichTextLabel
@onready var nine_patch_rect = $GUI/NinePatchRect
@onready var tower = $GUI/NinePatchRect/VBoxContainer/Tower
@onready var target_mode = $GUI/NinePatchRect/VBoxContainer/TargetMode
@onready var target = $GUI/NinePatchRect/VBoxContainer/Target
@onready var wave = $GUI/HBoxContainer/Wave
@onready var life = $GUI/HBoxContainer/Life
@onready var money = $GUI/HBoxContainer/Money

@onready var tower_1 = $GUI/Panel/BuildMenu/Tower1
@onready var tower_2 = $GUI/Panel/BuildMenu/Tower2
@onready var tower_3 = $GUI/Panel/BuildMenu/Tower3

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
	tower_1.get_child(0).text = "10"
	tower_2.get_child(0).text = "30"
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
	wave.text = ("[center]" + "Wave: " + str(GameManager.map.wave) + "[/center]")
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

func buy_tower(tower_scene):
	if (is_building):
		var new_building = tower_scene.instantiate()
		if (building.name == new_building.name):
			print("Building the same")
		else:
			if (economy.money >= new_building.build_cost):
				building.queue_free()
				building = new_building
				selected_building = new_building
				get_parent().add_child(new_building)
			else:
				print("Not enuf money")
	else:
		if (selected_building != null):
			selected_building.unselected.emit()
			nine_patch_rect.visible = false
			can_build = true
			is_building = false
			building = null
			selected_building = null
		else:
			building = tower_scene.instantiate()
			selected_building = building
			if (economy.money >= selected_building.build_cost):
				building.is_selected = true
				is_building = true
				get_parent().add_child(building)
			else:
				building = null
				selected_building = null
				print("Not enuf money")

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action_pressed("1") and can_build):
		buy_tower(TEST_TOWER)
	if (event.is_action_pressed("2") and can_build):
		buy_tower(BASIC_TOWER)

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
	if (can_build and not is_building):
		buy_tower(TEST_TOWER)

func _on_texture_button_2_pressed():
	if (can_build and not is_building):
		buy_tower(BASIC_TOWER)
