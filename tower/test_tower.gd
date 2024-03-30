class_name Tower extends Node2D

signal enemy_spotted(enemy)
signal placed
signal selected
signal unselected
signal build_area_cleared

@onready var TEST_PROJECTILE: PackedScene = preload("res://tower/test_projectile.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@onready var timer: Timer = $Timer
@onready var tower_collision: CollisionShape2D = $TowerArea/TowerCollision
@onready var tower_range = $Range/TowerRange
@onready var tower_area: Area2D = $TowerArea
@onready var reload_bar: ProgressBar = $ReloadBar

var attack_speed: float = 1
var can_shoot: bool = false
var can_build_here: bool = true
var is_placed: bool = false
var is_selected: bool = false
var build_obstacle: Array
var target_list: Array
var target_list_progress: Array
var target: Node2D
var target_index: Node2D
var target_first: Node2D
var target_index_progress: float
var target_first_progress: float

func _ready():
	placed.connect(tower_placed)
	selected.connect(tower_selected)
	unselected.connect(tower_unselected)
	tower_range.disabled = true
	tower_area.input_pickable = false
	target = self
	timer.wait_time = attack_speed
	timer.start()
	pass

func _process(delta):
	reload_bar.value = timer.wait_time - timer.time_left
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

func tower_placed():
	tower_range.disabled = false
	tower_range.visible = false
	is_placed = true
	await get_tree().create_timer(0.1).timeout
	tower_area.input_pickable = true
	await check_build_space()
	tower_area.monitoring = false
	
func tower_selected():
	tower_range.visible = true
	is_selected = true

func tower_unselected():
	tower_range.visible = false
	is_selected = false

func check_build_space():
	#print(self, " Before : ", can_build_here)
	if (tower_area.get_overlapping_areas().is_empty()):
		build_area_cleared.emit()
		tower_collision.debug_color = Color(0, 0.6, 0.7, 0.42)
	else:
		tower_collision.debug_color = Color(1, 0, 0, 0.5)
		if (is_placed and is_selected and get_parent().get_node("Player").is_building == false):
			print(self, " : Overlaped")
			queue_free()
	#print(self, " After : ", can_build_here, "\n")

func _on_timer_timeout() -> void:
	timer.stop()
	can_shoot = true
	#set_target()
	pass # Replace with function body.

func _on_range_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Enemy")):
		target_list.append(area.get_parent())
	pass # Replace with function body.

func _on_range_area_exited(area: Area2D) -> void:
	if (area.is_in_group("Enemy")):
		target_list.erase(area.get_parent())
	pass # Replace with function body.

func _on_tower_area_area_entered(area):
	if (area.is_in_group("Tower") or area.is_in_group("Obstacle")):
		can_build_here = false
		check_build_space()
		pass
	pass # Replace with function body.

func _on_tower_area_area_exited(area):
	if (area.is_in_group("Tower") or area.is_in_group("Obstacle")):
		can_build_here = true
		check_build_space()
		pass
	pass # Replace with function body.

func _on_tower_area_input_event(viewport, event, shape_idx):
	if (Input.is_action_just_pressed("LMB") and is_placed and get_parent().get_node("Player") == null):
		get_parent().get_node("Player").selected_building = self
		selected.emit()
		print("Select : ", self)
		#print(get_parent().get_node("Player"))
		#print(get_parent().get_node("Player").selected_building)
	pass # Replace with function body.
