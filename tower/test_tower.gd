extends Node2D

signal enemy_spotted(enemy)

@onready var TEST_PROJECTILE = preload("res://tower/test_projectile.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@onready var timer: Timer = $Timer
@onready var tower_collision = $TowerArea/TowerCollision
@onready var tower_area: Area2D = $TowerArea
@onready var reload_bar: ProgressBar = $ReloadBar

var attack_speed: float = 1
var can_shoot: bool = false
var can_build_here: bool = true
var build_obstacle: Array
var target_list: Array
var target_list_progress: Array
var target: Node2D
var target_index: Node2D
var target_first: Node2D
var target_index_progress: float
var target_first_progress: float

func _ready():
	target = self
	timer.wait_time = attack_speed
	timer.start()
	pass

func _physics_process(delta: float) -> void:
	reload_bar.value = timer.wait_time - timer.time_left
	set_target()
	pass

func placed():
	timer.start()

func set_target():
	#target_list = []
	target_list_progress = []
	if (target_list.size() != 0):
		for enemy in target_list:
			target_list_progress.append(enemy.progress)
		#print("Target Found : ", target_list.size())
		#print("Target List : ", target_list)
		#print("Target Progress Found : ", target_list.size())
		#print("Target List Progress: ", target_list_progress)
		#print("Max : ", target_list_progress.max())
		#print("Index : ", target_list_progress.find(target_list_progress.max()))
		target = target_list[target_list_progress.find(target_list_progress.max())]
		#target = target_list[target_list_progress.find(target_list_progress.min())]
		#print("Target : ", target, "\n")
		target.modulate = Color(1, 0, 0, 0.5)
		turn()
		if (can_shoot):
			shoot()
	elif (target == null):
		target = self

func turn():
	look_at(target.global_position)
	#look_at(get_global_mouse_position())

func shoot():
	timer.start()
	var bullet = TEST_PROJECTILE.instantiate()
	get_parent().add_child(bullet)
	bullet.position = marker_2d.global_position
	bullet.look_at(target.global_position)
	bullet.target = target.global_position - global_position
	can_shoot = false

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
		#build_obstacle.append(area)
		if (tower_area.get_overlapping_areas()):
			can_build_here = false
			tower_collision.debug_color = Color(1, 0, 0, 0.5)
	pass # Replace with function body.

func _on_tower_area_area_exited(area):
	if (area.is_in_group("Tower") or area.is_in_group("Obstacle")):
		#build_obstacle.erase(area)
		if (tower_area.get_overlapping_areas().is_empty()):
			can_build_here = true
			tower_collision.debug_color = Color(0, 0.6, 0.7, 0.42)
	pass # Replace with function body.
