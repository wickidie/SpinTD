class_name Tower extends Node2D

signal enemy_spotted(enemy)
signal placed
signal build_placed
signal selected
signal unselected
signal build_area_cleared

@onready var TEST_PROJECTILE: PackedScene = preload("res://tower/test_projectile.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@onready var timer: Timer = $Timer
@onready var tower_collision: CollisionShape2D = $TowerArea/TowerCollision
@onready var tower_range = $Range/TowerRange
@onready var tower_area: Area2D = $TowerArea
@onready var tower_click_area = $TowerClickArea
@onready var reload_bar: ProgressBar = $Debug/ReloadBar
@onready var debug_text = $Debug/HBox/RichTextLabel

var attack_speed: float = 1
var can_shoot: bool = false

var player: Player
var can_build_here: bool = true
var is_placed: bool = false
var is_selected: bool = false
var is_waiting: bool = false
var building_obstacles: Array

var target_list: Array
var target_list_progress: Array
var target: Node2D
var target_index: Node2D
var target_first: Node2D
var target_index_progress: float
var target_first_progress: float

func _ready():
	build_placed.connect(place_building)
	selected.connect(tower_selected)
	unselected.connect(tower_unselected)
	player = get_parent().get_node("Player")
	tower_range.disabled = true
	tower_area.input_pickable = false
	target = self
	timer.wait_time = attack_speed
	timer.start()
	waiting_to_build()
	pass

func _process(delta):
	#if (is_waiting and not player.is_precision_building):
		#position = get_global_mouse_position()
	reload_bar.value = timer.wait_time - timer.time_left
	debug_text.text = "can_build_here : " + str(can_build_here) + "\nis_placed : " + str(is_placed) + "\nis_selected : " + str(is_selected)
	pass
	
func _physics_process(delta: float) -> void:
	set_target()
	pass

func set_target():
	target_list_progress = []
	if (target_list.size() != 0):
		for enemy in target_list:
			target_list_progress.append(enemy.progress)
		target = target_list[target_list_progress.find(target_list_progress.max())]
		target.modulate = Color(1, 0, 0, 0.5)
		turn()
		if (can_shoot):
			shoot()
	elif (target == null):
		target = self

func turn():
	look_at(target.global_position)

func shoot():
	timer.start()
	var bullet: Bullet = TEST_PROJECTILE.instantiate()
	get_parent().add_child(bullet)
	bullet.position = marker_2d.global_position
	bullet.look_at(target.global_position)
	bullet.target = target.global_position - global_position
	can_shoot = false

func debug():
	print("Target Found : ", target_list.size())
	print("Target List : ", target_list)
	print("Target Progress Found : ", target_list.size())
	print("Target List Progress: ", target_list_progress)
	print("Max : ", target_list_progress.max())
	print("Index : ", target_list_progress.find(target_list_progress.max()))
	print("Target : ", target, "\n")

func waiting_to_build():
	is_waiting = true
		
func place_building():
	is_placed = true
	is_waiting = false
	is_selected = false
	tower_range.disabled = false
	tower_range.visible = false
	print("Building Placed : ", self)
	await get_tree().create_timer(0.1).timeout
# Delete new tower if illegally builded
	tower_area.monitoring = false
# Wait for next frame so the tower doesnt instantly selected
	tower_click_area.monitorable = true
	tower_click_area.input_pickable = true
	pass
	
func tower_selected():
	tower_range.visible = true
	is_selected = true

func tower_unselected():
	tower_range.visible = false
	is_selected = false

func check_build_space():
	if (building_obstacles.is_empty()):
		tower_collision.debug_color = Color(0, 0.6, 0.7, 0.42)
		can_build_here = true
		print(self, " Area Empty")
		return true
	elif (not building_obstacles.is_empty()):
		print(self, " Area not Empty")
		tower_collision.debug_color = Color(1, 0, 0, 0.5)
		can_build_here = false
		#player.is_precision_building = true
		if (is_placed):
			print(self, " : Illegal Builded")
			queue_free()
			return false
	else:
		print("ELSE")
		return false

func _on_timer_timeout() -> void:
	timer.stop()
	can_shoot = true

func _on_range_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Enemy")):
		target_list.append(area.get_parent())

func _on_range_area_exited(area: Area2D) -> void:
	if (area.is_in_group("Enemy")):
		target_list.erase(area.get_parent())

func _on_tower_area_area_entered(area):
	if (area.is_in_group("Tower") or area.is_in_group("Obstacle")):
		building_obstacles.append(area)
		check_build_space()

func _on_tower_area_area_exited(area):
	if (area.is_in_group("Tower") or area.is_in_group("Obstacle")):
		building_obstacles.remove_at(building_obstacles.find(area))
		check_build_space()

func _on_tower_click_area_input_event(viewport, event, shape_idx):
	if (Input.is_action_just_pressed("LMB") and is_placed and player.is_building == false):
		player.selected_building = self
		selected.emit()
		print("Select : ", self)
