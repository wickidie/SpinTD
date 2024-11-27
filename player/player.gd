class_name Player extends Node2D

@onready var TEST_TOWER: PackedScene = preload("res://tower/test/test_tower.tscn")
@onready var BASIC_TOWER: PackedScene = preload("res://tower/basic/tower_basic.tscn")

@onready var player_camera: Camera2D = $PlayerCamera
@onready var top: VisibleOnScreenNotifier2D = $CameraNotifier/Top
@onready var bottom: VisibleOnScreenNotifier2D = $CameraNotifier/Bottom
@onready var left: VisibleOnScreenNotifier2D = $CameraNotifier/Left
@onready var right: VisibleOnScreenNotifier2D = $CameraNotifier/Right

@onready var debug_label = $Debug/DebugLabel

@onready var wave = $GUI/HBoxContainer/Wave
@onready var lives_text = $GUI/HBoxContainer/Life
@onready var money_text = $GUI/HBoxContainer/Money

@onready var info_panel = $GUI/InfoPanel
@onready var tower = $GUI/InfoPanel/VBoxContainer/Tower
@onready var target_mode = $GUI/InfoPanel/VBoxContainer/HBoxContainer/TargetMode
@onready var target = $GUI/InfoPanel/VBoxContainer/Target
@onready var tower_image: TextureRect = $GUI/InfoPanel/VBoxContainer/MarginContainer/TowerImage

@onready var build_menu = $GUI/BuildPanel/BuildMenu
@onready var tower_menu_template: TextureButton = $GUI/BuildPanel/BuildMenu/TowerTemplate

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

#var economy: PlayerEconomy
var tower_list_path: Array
var tower_list: Array
var level_manager: LevelManager
var money

var player_camera_min_position: Vector2 = Vector2(0, 0)
var player_camera_max_position: Vector2 = Vector2(640, 360)
var zoom_sensitivity: Vector2 = Vector2(0.1, 0.1)
var player_camera_min_zoom: Vector2 = Vector2(1, 1)
var player_camera_max_zoom: Vector2 = Vector2(2, 2)

# TODO : Money text overflow if float or 5 digit mayb?
func _ready():
	level_manager = get_parent()
	money = level_manager.map.starting_money
	building_selected.connect(select_building)
	#GameManager.player_list.append(self)
	#economy = PlayerEconomy.new()
	info_panel.visible = false
	fill_build_panel()
	top.screen_entered.connect(mamamia)
	bottom.screen_entered.connect(mamamia)
	left.screen_entered.connect(mamamia)
	right.screen_entered.connect(mamamia)

func mamamia():
	print("mamamia")

func _process(delta):
	if (is_building):
		if (is_precision_building and Input.is_action_pressed("LMB")):
			show_precision_build()
		elif (not is_precision_building):
			show_build()

	debug_label.text = (
		"building : " + str(building) +
		"\nselected_building : " + str(selected_building) +
		"\nis_building : " + str(is_building) +
		"\nis_precision_building : " + str(is_precision_building) +
		"\ncan_build : " + str(can_build))
	wave.text = ("[center]" + "Wave: " + str(level_manager.map.wave) + "[/center]")
	lives_text.text = ("[center]" + "Life: " + str(level_manager.lives) + "[/center]")
	money_text.text = ("[center]" + "Money: " + str(money) + "[/center]")
	
	var speed = 100.0
	var direction = Vector2.ZERO
	
	if (Input.is_action_pressed("ui_up") && !top.is_on_screen()):  
		direction.y -= 1
		print(player_camera.position)
	if (Input.is_action_pressed("ui_down") && !bottom.is_on_screen()):
		direction.y += 1
		print(player_camera.position)
	if (Input.is_action_pressed("ui_left") && !left.is_on_screen()):
		direction.x -= 1
		print(player_camera.position)
	if (Input.is_action_pressed("ui_right") && !right.is_on_screen()):
		direction.x += 1
		print(player_camera.position)
	
	if (player_camera_min_position < player_camera.position):
		direction = direction.normalized() * speed * delta
		player_camera.position += direction
		#print(player_camera.position)
		#print(player_camera.get_screen_center_position())
		
func fill_build_panel():
	var tower_list_limit: int = 10
	tower_list_path = [
		"res://tower/test/test_tower.tscn",
		"res://tower/basic/tower_basic.tscn",
		"res://tower/gatling/tower_gatling.tscn"
	]
	for tower in tower_list_path:
		var temp_tower: Tower = load(tower).instantiate()
		tower_list.append(temp_tower)
		print(temp_tower.tower_name)

		var temp_tower_menu: TextureButton = tower_menu_template.duplicate()
		temp_tower_menu.visible = true
		temp_tower_menu.name = temp_tower.tower_name
		temp_tower_menu.set_meta("TowerPath", tower)
		temp_tower_menu.pressed.connect(buy_tower.bind(temp_tower_menu.get_meta("TowerPath")))
		temp_tower_menu.texture_normal = temp_tower.tower_icon
		temp_tower_menu.get_child(0).text = str(temp_tower.build_cost)
		temp_tower_menu.get_child(1).text = str(temp_tower.tower_name)
		build_menu.add_child(temp_tower_menu)
	
	if (len(tower_list_path) < 10):
		for i in range(tower_list_limit - len(tower_list_path)):
			var temp_tower_menu: TextureButton = tower_menu_template.duplicate()
			temp_tower_menu.visible = true
			build_menu.add_child(temp_tower_menu)
			temp_tower_menu.get_child(1).text = "Empty"

func show_build():
	building.position = get_global_mouse_position()

func show_precision_build():
	var temp_pos = precision_start_pos + (get_global_mouse_position() - precision_current_pos) / 3
	building.position = temp_pos

func build():
	building.build_placed.emit()
	money -= selected_building.build_cost
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
	if (get_global_mouse_position().x <=
	get_tree().root.get_viewport().get_window().content_scale_size.x / 2):
		info_panel.anchors_preset = Control.PRESET_TOP_RIGHT
	else:
		info_panel.anchors_preset = Control.PRESET_TOP_LEFT

	info_panel.visible = true
	tower.text = ("[center]" + str(selected_building.tower_name) + "[/center]")
	target_mode.text = str(selected_building.target_mode_string)
	target.text = ("[center]" + str(selected_building.target.name) + "[/center]")
	tower_image.texture = selected_building.tower_icon

func unselect_building():
	#print("Unselect : ", selected_building)
	selected_building.unselected.emit()
	selected_building = null
	print(selected_building)
	info_panel.visible = false

func buy_tower(tower_scene):
	if (is_building):
		var new_building = load(tower_scene).instantiate()
		if (building.name == new_building.name):
			print("Building the same")
		else:
			if (money >= new_building.build_cost):
				building.queue_free()
				building = new_building
				selected_building = new_building
				get_parent().add_child(new_building)
			else:
				print("Not enuf money")
	else:
		if (selected_building != null):
			selected_building.unselected.emit()
			info_panel.visible = false
			can_build = true
			is_building = false
			building = null
			selected_building = null
		else:
			building = load(tower_scene).instantiate()
			selected_building = building
			if (money >= selected_building.build_cost):
				building.is_selected = true
				is_building = true
				get_parent().add_child(building)
			else:
				building = null
				selected_building = null
				print("Not enuf money")

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action_pressed("1") and can_build):
		#print(tower_list.find("TowerTest"))
		print(tower_list.find("TowerTest"))
		buy_tower(tower_list_path[0])
	if (event.is_action_pressed("2") and can_build):
		#buy_tower(BASIC_TOWER)
		buy_tower(tower_list_path[1])
	if (event.is_action_pressed("3") and can_build):
		buy_tower(tower_list_path[2])

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
		
	if (event.is_action("mwheel_up")):
		if (player_camera.zoom < player_camera_max_zoom):
			player_camera.zoom += zoom_sensitivity
			print(player_camera.get_screen_center_position())
		
	if (event.is_action("mwheel_down")):
		if (player_camera.zoom > player_camera_min_zoom):
			player_camera.zoom -= zoom_sensitivity
			print(player_camera.get_screen_center_position())


func _on_target_change_left_pressed():
	selected_building.change_target_mode(-1)
	target_mode.text = str(selected_building.target_mode_string)
	print(selected_building.target_mode)
	print(selected_building.target_mode_string)

func _on_target_change_right_pressed():
	selected_building.change_target_mode(1)
	target_mode.text = str(selected_building.target_mode_string)
	print(selected_building.target_mode)
	print(selected_building.target_mode_string)

func _on_sell_tower_button_up():
	money += selected_building.build_cost / 2
	selected_building.queue_free()
	unselect_building()
	pass # Replace with function body.
