class_name Tower extends Node2D

signal enemy_spotted(enemy)
signal placed
signal build_placed
signal selected
signal unselected
signal build_area_cleared

enum TargetMode {FIRST, LAST}

var TowersData: Resource = preload("res://tower/towers_data.gd")

@onready var projectile: PackedScene
@onready var tower_base = $Base
@onready var tower_nozzle = $Nozzle
@onready var marker_2d = $Nozzle/Marker2D
@onready var timer: Timer = $Timer
@onready var tower_collision: CollisionShape2D = $TowerArea/TowerCollision
@onready var tower_range = $Range/TowerRange
@onready var tower_area: Area2D = $TowerArea
@onready var tower_click_area = $TowerClickArea
@onready var reload_bar: ProgressBar = $Debug/ReloadBar
@onready var debug_text = $Debug/HBox/RichTextLabel
@onready var ray_cast_2d = $RayCast2D

# Tower stats
var tower_name: String
var tower_icon
var build_cost: float
var attack_speed: float

var tower_owner: Player
var can_shoot: bool = false
var can_build_here: bool = true
var is_placed: bool = false
var is_selected: bool = false
var is_waiting: bool = false
var building_obstacles: Array

var target: Node2D
var target_index: Node2D
var target_first: Node2D
var target_list: Array
var target_list_progress: Array
var target_index_progress: float
var target_first_progress: float
var target_mode: TargetMode
var target_mode_string: String

func _ready():
	target_mode = randi_range(0, TargetMode.size() - 1)
	target_mode_to_string(target_mode)
	build_placed.connect(place_building)
	selected.connect(tower_selected)
	unselected.connect(tower_unselected)
	tower_owner = get_parent().get_node("Player")
	tower_range.disabled = true
	tower_area.input_pickable = false
	target = self
	timer.wait_time = 1 / attack_speed
	reload_bar.max_value = timer.wait_time
	timer.start()
	waiting_to_build()

func _process(_delta):
	reload_bar.value = reload_bar.max_value - timer.time_left
	debug_text.text = (
		"target_mode : " + str(target_mode))

func _physics_process(_delta: float) -> void:
	set_target()

func load_tower_stat(tower_name):
	var towers_data: TowersData = TowersData.new()
	build_cost = towers_data.towers_data[tower_name]["build_cost"]
	attack_speed = towers_data.towers_data[tower_name]["attack_speed"]
	projectile = load(towers_data.towers_data[tower_name]["projectile"])
	tower_icon = load(towers_data.towers_data[tower_name]["base"])

func set_target():
	target_list_progress = []
	if (target_list.size() != 0):
		for enemy in target_list:
			target_list_progress.append(enemy.progress)
			match target_mode:
				TargetMode.FIRST:
					target = target_list[target_list_progress.find(target_list_progress.max())]
				TargetMode.LAST:
					target = target_list[target_list_progress.find(target_list_progress.min())]
			target_mode_to_string(target_mode)
		ray_cast_2d.target_position = target.global_position - ray_cast_2d.global_position
		turn()
		if (can_shoot):
			shoot_projectile()
	elif (target == null):
		target = self

func target_mode_to_string(target_mode):
	match target_mode:
		TargetMode.FIRST:
			target_mode_string = "FIRST"
		TargetMode.LAST:
			target_mode_string = "LAST"

func change_target_mode(i: int):
	target_mode = abs((target_mode + i) % TargetMode.size())
	target_mode_to_string(target_mode)

func turn():
	tower_nozzle.look_at(target.global_position)

func shoot_projectile():
	timer.start()
	var bullet: Projectile = projectile.instantiate()
	get_parent().add_child(bullet)
	bullet.m_projectile_owner = tower_owner
	bullet.position = marker_2d.global_position
	bullet.start(target.global_position - global_position)
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
		if (is_placed):
			print(self, " : Illegal Builded")
			tower_owner.money += build_cost
			queue_free()
			return false
	else:
		print("ELSE")
		return false

# Reload timer
func _on_timer_timeout() -> void:
	timer.stop()
	can_shoot = true

# Tower target list
func _on_range_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Enemy")):
		target_list.append(area.get_parent())

func _on_range_area_exited(area: Area2D) -> void:
	if (area.is_in_group("Enemy")):
		target_list.erase(area.get_parent())

# Tower building obstacle
func _on_tower_area_area_entered(area):
	if (area.is_in_group("Tower") or area.is_in_group("Obstacle")):
		modulate += Color(1, 0, 0, 1)
		area.modulate += Color(1, 0, 0, 1)
		building_obstacles.append(area)
		check_build_space()

func _on_tower_area_area_exited(area):
	if (area.is_in_group("Tower") or area.is_in_group("Obstacle")):
		modulate -= Color(1, 0, 0, 1)
		area.modulate -= Color(1, 0, 0, 1)
		building_obstacles.remove_at(building_obstacles.find(area))
		check_build_space()

# Receiving tower_owner mouse input to select
func _on_tower_click_area_input_event(_viewport, _event, _shape_idx):
	if (Input.is_action_just_pressed("LMB") and is_placed and tower_owner.is_building == false):
		tower_owner.selected_building = self
		selected.emit()
		tower_owner.building_selected.emit()
		print("Select : ", self)
